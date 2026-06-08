import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:project_tpm/screens/MainMenu.dart';
import 'package:project_tpm/screens/register.dart';
import 'package:project_tpm/services/user_service.dart';
import 'package:project_tpm/shared/color_palette.dart';
import 'package:project_tpm/models/user.dart';
import 'package:project_tpm/utils/rsa_helper.dart';
import 'package:project_tpm/utils/session_manager.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool isLoginSuccess = true;

class _LoginPageState extends State<LoginPage> {
  final userService = UserService();
  final profileManager = UserProfileManager();
  String username = "";
  String password = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final profile = await profileManager.getUserProfile();
    if (profile != null && profile['isLoggedIn'] == true) {
      // Jika sudah login, langsung pindah ke MainMenu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : width * 0.2,
                    vertical: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Image.asset(
                          "assets/3.png",
                          width: isMobile ? width * 0.7 : 280,
                          height: isMobile ? width * 0.7 : 280,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: 400,
                        ),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _usernameField(),
                            _passwordField(),
                            SizedBox(height: 12),
                            _loginButton(context),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Doesn't Have an Account?"),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: accentColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(),
                                      ),
                                    );
                                  },
                                  child: Text("Register"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _usernameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        enabled: true,
        onChanged: (value) {
          username = value;
        },
        decoration: InputDecoration(
          hintText: "Username",
          contentPadding: EdgeInsets.all(12.0),
          filled: true,
          fillColor: whiteColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
              color: (isLoginSuccess) ? secondaryColor : dangerColor,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
              color: secondaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        enabled: true,
        obscureText: true,
        onChanged: (value) {
          password = value;
        },
        decoration: InputDecoration(
          hintText: "Password",
          contentPadding: EdgeInsets.all(12.0),
          filled: true,
          fillColor: whiteColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
              color: (isLoginSuccess) ? secondaryColor : dangerColor,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
              color: secondaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: whiteColor,
          backgroundColor: accentColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          String text = "";

          final user = await userService.getUserByUsername(username);

          if (user == null || user.publicKey == null) {
            setState(() {
              isLoginSuccess = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      "User tidak ditemukan atau public key tidak tersedia")),
            );
            return;
          }

          // Ambil public key dari user dan enkripsi password input
          final publicKey = CryptoUtils.rsaPublicKeyFromPem(user.publicKey!);
          final encryptedPassword =
              await RSAHelper.encrypt(password, publicKey);

          // Login pakai password yang sudah dienkripsi
          final data = await userService.login(username, encryptedPassword);

          if (data) {
            setState(() {
              text = "Login success!";
              isLoginSuccess = true;
            });
            await profileManager.saveUserProfile(
              id: user!.id!,
              username: user.username,
              password: user.password,
              birthdate: user.dateOfBirth,
              gender: user.gender,
              publicKey: user.publicKey,
              isLoggedIn: true, // user sudah login
            );
          } else {
            setState(() {
              text = "Username atau Password Salah!";
              isLoginSuccess = false;
            });
          }
          SnackBar snackBar = SnackBar(content: Text(text));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          if (isLoginSuccess == true && user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainMenu(),
              ),
            );
          }
        },
        child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class WindFlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = secondaryColor.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    Path path1 = Path();
    path1.moveTo(0, size.height * 0.2);
    path1.cubicTo(size.width * 0.2, size.height * 0.1, size.width * 0.8,
        size.height * 0.3, size.width, size.height * 0.2);
    canvas.drawPath(path1, paint);

    Path path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    path2.cubicTo(size.width * 0.3, size.height * 0.4, size.width * 0.7,
        size.height * 0.6, size.width, size.height * 0.5);
    canvas.drawPath(path2, paint..color = secondaryColor.withOpacity(0.18));

    Path path3 = Path();
    path3.moveTo(0, size.height * 0.8);
    path3.cubicTo(size.width * 0.1, size.height * 0.7, size.width * 0.9,
        size.height * 0.9, size.width, size.height * 0.8);
    canvas.drawPath(path3, paint..color = accentColor.withOpacity(0.15));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

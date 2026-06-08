import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:project_tpm/models/user.dart';
import 'package:project_tpm/screens/Login.dart';
import 'package:project_tpm/services/user_service.dart';
import 'package:project_tpm/shared/color_palette.dart';
import 'package:project_tpm/utils/rsa_helper.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

bool isRegisterSuccess = true;

class _RegisterPageState extends State<RegisterPage> {
  final userService = UserService();
  String username = "";
  String password = "";
  String? gender;
  DateTime? dateOfBirth;

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
                        "Register",
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
                            _genderField(),
                            _dateOfBirthField(context),
                            SizedBox(height: 12),
                            _registerButton(context),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already Have an Account?"),
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
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  },
                                  child: Text("Login"),
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
              color: isRegisterSuccess ? secondaryColor : dangerColor,
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
              color: isRegisterSuccess ? secondaryColor : dangerColor,
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

  Widget _genderField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gender"),
          Row(
            children: [
              Radio<String>(
                value: "Male",
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              Text("Male"),
              Radio<String>(
                value: "Female",
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              Text("Female"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateOfBirthField(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: dateOfBirth ?? DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              dateOfBirth = pickedDate;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(
                color: isRegisterSuccess ? secondaryColor : dangerColor,
                width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateOfBirth == null
                    ? "Select Date of Birth"
                    : "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}",
                style: TextStyle(fontSize: 16),
              ),
              Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: whiteColor,
          backgroundColor: (isRegisterSuccess) ? accentColor : dangerColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          String text = "";

          // Cek dan generate kunci RSA jika belum ada
          RSAPublicKey? publicKey = await RSAHelper.getPublicKey();
          if (publicKey == null) {
            await RSAHelper.generateAndStoreKeys(); // generate baru
            publicKey = await RSAHelper.getPublicKey(); // ambil lagi
          }

          if (publicKey == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed to generate public key."),
              ),
            );
            return;
          }

          final encryptedPassword =
              await RSAHelper.encrypt(password, publicKey);

          final newUser = User(
            username: username,
            password: encryptedPassword,
            gender: gender,
            dateOfBirth: dateOfBirth,
          );

          final success = await userService.addUser(newUser);

          setState(() {
            isRegisterSuccess = success;
            text = success ? "Register success!" : "Register failed!";
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(text)));

          if (isRegisterSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        },
        child: Text("Register", style: TextStyle(fontWeight: FontWeight.bold)),
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

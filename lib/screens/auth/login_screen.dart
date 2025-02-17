import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sickle_cell_app/screens/auth/sign_up_screen.dart';
import 'package:sickle_cell_app/widgets/button.dart';
import 'package:sickle_cell_app/widgets/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController textController = TextEditingController();
  void signUserIn() async {}

  void showErrorMessage(String message) {
    // Tampilkan dialog dengan pesan error
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  String _errorMessage = "";

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email cannot be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Enter a valid email";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 0),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Colors.black,
                  ],
                  center: Alignment.center,
                  radius: 1,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.01),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 80,
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            'SICKLE CARE',
                            style: GoogleFonts.patrickHand(
                              textStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: height * 0.68,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Log In",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#4f4f4f"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          onChanged: (() {
                            // validateEmail(emailController.text);
                          }),
                          // controller: () {},
                          hintText: "hello@email.com",
                          obscureText: false,
                          prefixIcon: const Icon(Icons.mail_outline),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(
                            _errorMessage,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Password",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          // controller: () {},
                          hintText: "**************",
                          obscureText: true,
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyButton(
                          onPressed: signUserIn,
                          buttonText: 'Submit',
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
                          child: Row(
                            children: [
                              Text("Don't have an account?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: HexColor("#8d8d8d"),
                                  )),
                              TextButton(
                                child: Text(
                                  "SignUp",
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

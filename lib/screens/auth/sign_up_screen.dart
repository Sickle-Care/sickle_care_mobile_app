import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sickle_cell_app/constants/dropdown_values.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/providers/user_provider.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/screens/auth/login_screen.dart';
import 'package:sickle_cell_app/screens/tabs_screen.dart';
import 'package:sickle_cell_app/services/user_service.dart';
import 'package:sickle_cell_app/widgets/button.dart';
import 'package:sickle_cell_app/widgets/my_text_field.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  final contactNumberController = TextEditingController();
  final emergencyContactNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String genderValue = gender.first;
  String cellTypeValue = cellType.first;
  final maskFormatter = MaskTextInputFormatter(
    mask: '+1 (###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void signUserUp() async {
    try {
      UserService userService = UserService();
      var response = await userService.signUp(
        SignUpRequestModel(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          age: int.parse(ageController.text),
          contactNumber: contactNumberController.text,
          secConNumber: emergencyContactNumberController.text,
          userType: "patient",
          sickleCellType: cellTypeValue,
          gender: genderValue,
          email: emailController.text,
          password: passwordController.text,
        ),
      );

      if (response.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', response.user!.userId);
        await prefs.setBool('loginSuccess', true);
        ref.read(userProvider.notifier).setUser(response.user!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabsScreen(), // Pass user here
          ),
        );
      } else {
        showErrorSnackbar(
            response.error ?? "Signup failed. Please try again.", context);
      }
    } catch (e) {
      showErrorSnackbar("An error occurred: $e", context);
    }
  }

  void showErrorMessage(String message) {
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

  void validatePassword(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Password cannot be empty";
      });
    } else if (val.length < 6) {
      setState(() {
        _errorMessage = "Password must be at least 6 characters";
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
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#4f4f4f"),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "First Name",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: firstNameController,
                              keyboardType: TextInputType.text,
                              cursorColor: HexColor("#4f4f4f"),
                              decoration: InputDecoration(
                                hintText: "John",
                                fillColor: HexColor("#f0f3f1"),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: HexColor("#8d8d8d"),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Last Name",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: lastNameController,
                              keyboardType: TextInputType.text,
                              cursorColor: HexColor("#4f4f4f"),
                              decoration: InputDecoration(
                                hintText: "Doe",
                                fillColor: HexColor("#f0f3f1"),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: HexColor("#8d8d8d"),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Age",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              cursorColor: HexColor("#4f4f4f"),
                              decoration: InputDecoration(
                                hintText: "18",
                                fillColor: HexColor("#f0f3f1"),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: HexColor("#8d8d8d"),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Gender",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            DropdownButton<String>(
                              value: genderValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                              isExpanded: true,
                              underline: Container(
                                height: 2,
                                color: HexColor("#ffffff"),
                              ),
                              iconSize: 30,
                              borderRadius: BorderRadius.circular(20),
                              onChanged: (String? value) {
                                setState(() {
                                  genderValue = value!;
                                  // signUpController.setUserType(value);
                                });
                              },
                              items: gender.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Sickle Cell Type",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            DropdownButton<String>(
                              value: cellTypeValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                              isExpanded: true,
                              underline: Container(
                                height: 2,
                                color: HexColor("#ffffff"),
                              ),
                              iconSize: 30,
                              borderRadius: BorderRadius.circular(20),
                              onChanged: (String? value) {
                                setState(() {
                                  cellTypeValue = value!;
                                  // signUpController.setUserType(value);
                                });
                              },
                              items: cellType.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Contact Number",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: contactNumberController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [maskFormatter],
                              cursorColor: HexColor("#4f4f4f"),
                              decoration: InputDecoration(
                                hintText: "+1 (XXX) XXX-XXX",
                                fillColor: HexColor("#f0f3f1"),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: HexColor("#8d8d8d"),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Emergency Contact Number",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: emergencyContactNumberController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [maskFormatter],
                              cursorColor: HexColor("#4f4f4f"),
                              decoration: InputDecoration(
                                hintText: "+1 (XXX) XXX-XXX",
                                fillColor: HexColor("#f0f3f1"),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: HexColor("#8d8d8d"),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Email",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            MyTextField(
                              controller: emailController,
                              onChanged: (() {
                                validateEmail(emailController.text);
                              }),
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
                            const SizedBox(height: 10),
                            Text(
                              "Password",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            MyTextField(
                              controller: passwordController,
                              onChanged: (() {
                                validatePassword(passwordController.text);
                              }),
                              hintText: "**************",
                              obscureText: true,
                              prefixIcon: const Icon(Icons.lock_outline),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    MyButton(
                      onPressed: signUserUp,
                      buttonText: 'Submit',
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(width * 0.04, 0, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            "Already have an account?",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: HexColor("#8d8d8d"),
                            ),
                          ),
                          TextButton(
                            child: Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            ),
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
    );
  }
}

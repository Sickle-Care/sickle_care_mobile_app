import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sickle_cell_app/constants/dropdown_values.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/services/user_service.dart';
import 'package:sickle_cell_app/widgets/button.dart';
import 'package:sickle_cell_app/widgets/my_text_field.dart';

class AddUserScreen extends ConsumerStatefulWidget {
  const AddUserScreen({super.key, required this.userRole});

  final String userRole;

  @override
  ConsumerState<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends ConsumerState<AddUserScreen> {
  final User user = User(
      userId: "",
      firstName: "",
      lastName: "",
      email: "",
      userType: "",
      contactNumber: "");
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  final contactNumberController = TextEditingController();
  final emergencyContactNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final doctorLicenseNumberController = TextEditingController();
  String genderValue = gender.first;
  String cellTypeValue = cellType.first;

  @override
  void initState() {
    super.initState();
  }

  final maskFormatter = MaskTextInputFormatter(
    mask: '+1 (###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void saveDetails() async {
    try {
      UserService userService = UserService();
      var response = await userService.signUp(
        SignUpRequestModel(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          age: int.parse(ageController.text),
          contactNumber: contactNumberController.text,
          secConNumber: emergencyContactNumberController.text,
          userType: widget.userRole,
          sickleCellType: cellTypeValue,
          gender: genderValue,
          email: emailController.text,
          password: passwordController.text,
          doctorLicenseNumber: doctorLicenseNumberController.text,
        ),
      );
      if (response.user!.patientId != "") {
        Navigator.of(context).pop(true);
      } else {
        showErrorSnackbar("An error occurred. Please try again", context);
      }
    } catch (e) {
      showErrorSnackbar("An error occurred. Please try again.", context);
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white),
        title: Text(
          "Add ${widget.userRole}",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.1, vertical: height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                          image: AssetImage(
                              'assets/images/propic_placeholder.jpg.avif')),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 20),
              Text(
                "First Name",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      color: HexColor("#8d8d8d"),
                    ),
              ),
              DropdownButton<String>(
                value: genderValue,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                items: gender.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (widget.userRole == "Patient") ...[
                Text(
                  "Sickle Cell Type",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        color: HexColor("#8d8d8d"),
                      ),
                ),
                DropdownButton<String>(
                  value: cellTypeValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                  items: cellType.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
              if (widget.userRole == "Doctor") ...[
                Text(
                  "License Number",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        color: HexColor("#8d8d8d"),
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: doctorLicenseNumberController,
                  keyboardType: TextInputType.name,
                  cursorColor: HexColor("#4f4f4f"),
                  decoration: InputDecoration(
                    hintText: "1278B243",
                    fillColor: HexColor("#f0f3f1"),
                    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
              ],
              const SizedBox(height: 15),
              Text(
                "Contact Number",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Password",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15,
                      color: HexColor("#8d8d8d"),
                    ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: "**************",
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              const SizedBox(height: 30),
              MyButton(
                onPressed: saveDetails,
                buttonText: 'Add ${widget.userRole}',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/screens/OtpScreen/OtpScreen.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? selectedRole;
  BuildContext? dialogContext;
  String? selectGender;

  bool _isPasswordVisible = true;
  bool _isConPasswordVisible = true;

  bool isValidMobile(String mobile) {
    RegExp regExp = RegExp(r'^01\d{9}$');
    return regExp.hasMatch(mobile);
  }

  signUp(String name, String mobileNumber, String password, String address,
      int age, String role, String gender) async {
    try {
      if (!isValidMobile(mobileNumber)) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'Invalid mobile number',
          desc: 'Enter your right mobile number',
          btnOkText: 'OK',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {},
        ).show();
        Navigator.pop(dialogContext!);
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return const AlertDialog(
            backgroundColor: Colors.transparent,
            content: SpinKitCircle(color: Colors.white, size: 50.0),
          );
        },
      );

      final Map<String, dynamic> reqBody = {
        'name': name,
        'mobileNumber': mobileNumber,
        'password': password,
        'address': address,
        'age': age,
        'class': '',
        'gender': gender,
        'img': '',
        'role': role,
        'isVerified': false,
        'isAdmin': false,
      };

      final response = await post(
        Uri.parse('https://poralekha-server-chi.vercel.app/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );

      print("status code ${response.statusCode}");

      if (response.statusCode == 200) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          title: 'Account Created Successfully',
          desc: 'Please enter your OTP.',
          btnOkText: 'OK',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OtpScreen(mobileNumber: phoneController.text),
              ),
            );
          },
        ).show();
        final data = json.decode(response.body);
        final String authToken = data['token'];
        print(authToken);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', authToken);
        Navigator.pop(dialogContext!);
      } else {
        final data = json.decode(response.body);
        final errorMessage = data['msg'];
        print("My msg${errorMessage}");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: errorMessage.toString(),
          btnOkText: 'OK',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {},
        ).show();
        Navigator.pop(dialogContext!);
      }
    } catch (e) {
      print(e.toString());
      // Handle other exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyTheme.canvousColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1, vertical: screenHeight * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/poralekha-splash-screen-logo.png",
                  width: screenWidth * 0.4,
                ),
                SizedBox(height: screenHeight * 0.02),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Name",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // const SizedBox(
                //   height: 6,
                // ),
                CommonTextField(
                  controller: nameController,
                  text: "Name",
                  obscure: false,
                  suffixIcon: const Icon(IconsaxBold.user),
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Phone",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // const SizedBox(
                //   height: 6,
                // ),
                CommonTextField(
                  controller: phoneController,
                  text: "Phone",
                  obscure: false,
                  suffixIcon: const Icon(IconsaxBold.mobile),
                  textInputType: TextInputType.phone,
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Address",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // const SizedBox(
                //   height: 6,
                // ),
                CommonTextField(
                  controller: addressController,
                  text: "Address",
                  obscure: false,
                  suffixIcon: const Icon(IconsaxBold.location),
                  textInputType: TextInputType.streetAddress,
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Age",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // const SizedBox(
                //   height: 6,
                // ),
                CommonTextField(
                  controller: ageController,
                  text: "Age",
                  obscure: false,
                  suffixIcon: const Icon(IconsaxBold.calendar),
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Gender",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // const SizedBox(
                //   height: 6,
                // ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.02),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1), blurRadius: 2)
                      ]),
                  child: DropdownButtonFormField<String>(
                    value: selectGender,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectGender = newValue;
                      });
                    },
                    items: ['Male', 'Female', "Other"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        // labelText: 'Genderss',
                        hintText: "Gender"
                        // suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Role",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // const SizedBox(
                //   height: 6,
                // ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.02),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                      )
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    },
                    items: ['Student', 'Teacher']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Role",
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // const SizedBox(
                //   height: 6,
                // ),
                CommonTextField(
                  controller: passwordController,
                  text: "Password",
                  obscure: _isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? IconsaxBold.eye_slash
                        : IconsaxBold.eye),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Confirm Password",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // const SizedBox(
                //   height: 6,
                // ),
                CommonTextField(
                  controller: confirmPasswordController,
                  text: "Confirm Password",
                  obscure: _isConPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(_isConPasswordVisible
                        ? IconsaxBold.eye_slash
                        : IconsaxBold.eye),
                    onPressed: () {
                      setState(() {
                        _isConPasswordVisible = !_isConPasswordVisible;
                      });
                    },
                  ),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: screenHeight * 0.02),
                RoundedButton(
                  title: "Sign Up",
                  width: double.infinity,
                  onTap: () {
                    if (nameController.text.trim().isEmpty ||
                        phoneController.text.trim().isEmpty ||
                        passwordController.text.trim().isEmpty ||
                        addressController.text.trim().isEmpty ||
                        ageController.text.trim().isEmpty ||
                        selectedRole == null ||
                        selectGender == null) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Enter Required Fields',
                        btnOkColor: MyTheme.buttonColor,
                        btnOkOnPress: () {},
                      ).show();
                    } else if (confirmPasswordController.text.trim() !=
                        passwordController.text.trim()) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: "Password and Confirm password don't match",
                        btnOkColor: MyTheme.buttonColor,
                        btnOkOnPress: () {},
                      ).show();
                    } else {
                      signUp(
                          nameController.text.trim(),
                          phoneController.text.trim(),
                          passwordController.text.trim(),
                          addressController.text.trim(),
                          int.parse(ageController.text.trim()),
                          selectedRole ?? "Student",
                          selectGender ?? "");
                    }
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.04,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04,
                          color: Color(0xFF7E59FD),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context, isLoading) {
    if (isLoading) {
      ;
    }
  }
}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/screens/Login/LoginScreen.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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

  Future addUserDetails(String name, String email, String address, int age,
      String role, String gender, UserCredential? userCredential) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential?.user?.uid)
          .set({
        'name': name,
        'email': email,
        'address': address,
        'age': age,
        'role': selectedRole,
        'gender': selectGender,
        'isAdmin': false,
        'isApproved': false,
        'class': '',
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      print('Adding user data error: $e');
    }
    Navigator.pop(dialogContext!);
    try {
      await userCredential?.user?.sendEmailVerification();
    } catch (e) {
      print('Email verification send error: $e');
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      title: 'Please check your email and verify',
      btnOkColor: MyTheme.buttonColor,
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }

  signUp(String name, String email, String password, String address, int age,
      String role, String gender, String confirmPassword) async {
    if (password != confirmPassword) {
      // Passwords don't match, show alert

      return AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: "The password and confirm password do not match.",
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      )..show();
    } else {
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
    }

    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      addUserDetails(name, email, address, age, role, gender, userCredential);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(dialogContext!);
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: ex.message.toString(),
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      )..show();
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
                  suffixIcon: const Icon(Icons.person),
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Email",
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
                  controller: emailController,
                  text: "Email",
                  obscure: false,
                  suffixIcon: const Icon(Icons.email),
                  textInputType: TextInputType.emailAddress,
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
                  suffixIcon: const Icon(Icons.location_on),
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
                  suffixIcon: const Icon(Icons.calendar_today),
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
                        ? Icons.visibility_off
                        : Icons.visibility),
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
                        ? Icons.visibility_off
                        : Icons.visibility),
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
                        emailController.text.trim().isEmpty ||
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
                    } else {
                      // showDialog(
                      //   context: context,
                      //   barrierDismissible: false,
                      //   builder: (BuildContext context) {
                      //     dialogContext = context;
                      //     return const AlertDialog(
                      //       backgroundColor: Colors.transparent,
                      //       content:
                      //           SpinKitCircle(color: Colors.white, size: 50.0),
                      //     );
                      //   },
                      // );
                      signUp(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        addressController.text.trim(),
                        int.parse(ageController.text.trim()),
                        selectedRole ?? "Student",
                        selectGender ?? "",
                        confirmPasswordController.text.trim(),
                      );
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

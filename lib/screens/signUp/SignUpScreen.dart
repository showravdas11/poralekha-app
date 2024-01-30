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

  String? selectedRole;
  BuildContext? dialogContext;
  String? selectGender;

  Future addUserDetails(
      String name, String email, String address, int age, String role) async {
    await FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'email': email,
      'address': address,
      'age': age,
      'role': selectedRole,
      'gender': selectGender,
      'isAdmin': false,
      'isApproved': false,
      'class': ''
    });
    Navigator.pop(dialogContext!);
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
      String role) async {
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        addUserDetails(name, email, address, age, role);
      });
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
    return Scaffold(
      backgroundColor: MyTheme.canvousColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/poralekha-splash-screen-logo.png",
                  width: 160,
                ),
                const SizedBox(height: 40),
                CommonTextField(
                  controller: nameController,
                  text: "Name",
                  obscure: false,
                  suffixIcon: const Icon(Icons.person),
                  textInputType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                CommonTextField(
                  controller: emailController,
                  text: "Email",
                  obscure: false,
                  suffixIcon: const Icon(Icons.email),
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CommonTextField(
                  controller: addressController,
                  text: "Address",
                  obscure: false,
                  suffixIcon: const Icon(Icons.location_on),
                  textInputType: TextInputType.streetAddress,
                ),
                const SizedBox(height: 20),
                CommonTextField(
                  controller: ageController,
                  text: "Age",
                  obscure: false,
                  suffixIcon: const Icon(Icons.calendar_today),
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(6),
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
                      labelText: 'Gender',
                      // suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1), blurRadius: 2)
                      ]),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Role',
                      // suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CommonTextField(
                  controller: passwordController,
                  text: "Password",
                  obscure: true,
                  suffixIcon: const Icon(Icons.remove_red_eye),
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 30),
                RoundedButton(
                  title: "Sign Up",
                  width: 250,
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
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          dialogContext = context;
                          return const AlertDialog(
                            backgroundColor: Colors.transparent,
                            content:
                                SpinKitCircle(color: Colors.white, size: 50.0),
                          );
                        },
                      );
                      signUp(
                          nameController.text.trim(),
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          addressController.text.trim(),
                          int.parse(ageController.text.trim()),
                          selectedRole ?? "Student");
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
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

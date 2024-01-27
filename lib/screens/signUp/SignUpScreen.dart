import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poralekha_app/bottomNavBar/BottomNavBar.dart';
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
  final TextEditingController roleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;

  signUp(String name, String email, String password) async {
    if (email == "" && password == "") {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Enter Required Fields',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      ).show();
    } else {
      UserCredential? usercredential;
      try {
        usercredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BottomNavBar()));
        });
      } on FirebaseAuthException catch (ex) {
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: ex.code.toString(),
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {},
        )..show();
      }
    }

    addUserDetails(
      nameController.text.trim(),
      emailController.text.trim(),
      addressController.text.trim(),
      int.parse(
        ageController.text.trim(),
      ),
      roleController.text.trim(),
    );
  }

  Future addUserDetails(
      String name, String email, String address, int age, String role) async {
    await FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'email': email,
      'address': address,
      'age': age,
      'role': selectedRole,
      'isAdmin': false,
      'isApproved': false,
      'class': ''
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.canvousColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/poralekha-splash-screen-logo.png",
                  width: 160,
                ),
                SizedBox(height: 40),
                CommonTextField(
                  controller: nameController,
                  text: "Name",
                  obscure: false,
                  suffixIcon: Icon(Icons.person),
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: 20),
                CommonTextField(
                  controller: emailController,
                  text: "Email",
                  obscure: false,
                  suffixIcon: Icon(Icons.email),
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                CommonTextField(
                  controller: addressController,
                  text: "Address",
                  obscure: false,
                  suffixIcon: Icon(Icons.location_on),
                  textInputType: TextInputType.streetAddress,
                ),
                SizedBox(height: 20),
                CommonTextField(
                  controller: ageController,
                  text: "Age",
                  obscure: false,
                  suffixIcon: Icon(Icons.calendar_today),
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Container(
                  height: 55,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Role',
                      // suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CommonTextField(
                  controller: passwordController,
                  text: "Password",
                  obscure: true,
                  suffixIcon: Icon(Icons.remove_red_eye),
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 30),
                RoundedButton(
                  title: "Sign Up",
                  width: 250,
                  onTap: () {
                    signUp(
                      nameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  },
                ),
                SizedBox(height: 20),
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
                      child: Text(
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
}

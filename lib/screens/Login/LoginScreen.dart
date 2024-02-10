import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poralekha_app/bottomNavBar/BottomNavBar.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/screens/ForgetPassword/ForgetPassword.dart';
import 'package:poralekha_app/screens/signUp/SignUpScreen.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  bool _isPasswordVisible = true;

  login(String email, String password) async {
    if (email == '' && password == '') {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Enter Required Fields',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      )..show();
    } else {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        User? user = userCredential.user;

        if (user != null && user.emailVerified) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BottomNavBar()));
        } else {
          await userCredential.user?.sendEmailVerification();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: "Please check your email and verify",
            btnOkColor: MyTheme.buttonColor,
            btnOkOnPress: () {},
          )..show();
        }
      } on FirebaseAuthException catch (ex) {
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: ex.code.toString(),
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {},
        )..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyTheme.canvousColor,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1, vertical: screenHeight * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              CommonTextField(
                controller: emailController,
                text: "Email",
                obscure: false,
                suffixIcon: Icon(Icons.email),
                textInputType: TextInputType.emailAddress,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password ?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7E59FD)),
                    ),
                  )
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              RoundedButton(
                  title: "Login",
                  width: double.infinity,
                  onTap: () {
                    login(emailController.text.toString(),
                        passwordController.text.toString());
                  }),
              // SizedBox(height: 20),
              // SocialButton(text: "-or sign in with-"),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.04,
                        color: Colors.black.withOpacity(0.5)),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.04,
                            color: Color(0xFF7E59FD)),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

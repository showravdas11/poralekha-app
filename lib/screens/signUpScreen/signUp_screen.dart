import 'package:flutter/material.dart';
import 'package:poralekha_app/common/button.dart';
import 'package:poralekha_app/common/text_filed.dart';
import 'package:poralekha_app/screens/loginScreen/login_screen.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:poralekha_app/widgets/social_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.WhiteColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      wordSpacing: 2,
                      color: Color(0xFF375FBE),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                //Name Field
                TextFormFiledCommon(
                  controller: nameController,
                  text: "Name",
                  obscure: false,
                  suffixIcon: Icon(Icons.person),
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 30,
                ),
                //Email Field
                TextFormFiledCommon(
                  controller: emailController,
                  text: "Email",
                  obscure: false,
                  suffixIcon: Icon(Icons.email),
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 30,
                ),
                //Password Field
                TextFormFiledCommon(
                  controller: passwordController,
                  text: "Password",
                  obscure: true,
                  suffixIcon: Icon(Icons.remove_red_eye),
                  textInputType: TextInputType.text,
                ),
                SizedBox(
                  height: 30,
                ),
                RoundedButton(title: "Sign Up", width: 250, onTap: () {}),
                SizedBox(height: 20),
                SocialButton(text: "-or sign up with-"),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " have an account?",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.5)),
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
                              color: Color(0xFF375FBE)),
                        ))
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

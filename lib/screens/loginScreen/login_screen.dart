import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poralekha_app/bottomNavBar/bottom_nav_bar.dart';
import 'package:poralekha_app/common/button.dart';
import 'package:poralekha_app/common/text_filed.dart';
import 'package:poralekha_app/screens/forgetPasswordScreen/forgotPass_screen.dart';
import 'package:poralekha_app/screens/tabscreen/home_screen.dart';
import 'package:poralekha_app/screens/signUpScreen/signUp_screen.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:poralekha_app/widgets/social_button.dart';

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
      UserCredential? usercredential;
      try {
        usercredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
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
  }

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
                    "Login",
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
                  height: 40,
                ),
                TextFormFiledCommon(
                  controller: emailController,
                  text: "Email",
                  obscure: false,
                  suffixIcon: Icon(Icons.email),
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormFiledCommon(
                  controller: passwordController,
                  text: "Password",
                  obscure: true,
                  suffixIcon: Icon(Icons.remove_red_eye),
                  textInputType: TextInputType.text,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Color(0xFFFFFFFF),
                          activeColor: Color(0xFF375FBE),
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity:
                              VisualDensity(horizontal: -4.0, vertical: -4.0),
                        ),
                        Text(
                          "Remember me",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF375FBE)),
                        ),
                      ],
                    ),
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
                            color: Color(0xFF375FBE)),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                RoundedButton(
                    title: "Login",
                    width: 250,
                    onTap: () {
                      login(emailController.text.toString(),
                          passwordController.text.toString());
                    }),
                // SizedBox(height: 20),
                // SocialButton(text: "-or sign in with-"),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
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
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
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

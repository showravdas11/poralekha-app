import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:poralekha_app/MainScreen/MainScreen.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/screens/ForgetPassword/ForgetPassword.dart';
import 'package:poralekha_app/screens/signUp/SignUpScreen.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late SharedPreferences _preferences;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isPasswordVisible = true;

  bool isValidMobile(String mobile) {
    RegExp regExp = RegExp(r'^01\d{9}$');
    return regExp.hasMatch(mobile);
  }

  @override
  void initState() {
    super.initState();
    // _initPreferences();
  }

  // void _initPreferences() async {
  //   _preferences = await SharedPreferences.getInstance();
  //   final String? authToken = _preferences.getString('authToken');
  //   if (authToken != null && authToken.isNotEmpty) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => MainScreen()),
  //     );
  //   } else {
  //     AwesomeDialog(
  //       context: context,
  //       dialogType: DialogType.error,
  //       animType: AnimType.bottomSlide,
  //       title: 'Please Sign Up',
  //       desc: 'You need to sign up to access the app.',
  //       btnOkText: 'Sign Up',
  //       btnOkColor: MyTheme.buttonColor,
  //       btnOkOnPress: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => SignUpScreen()),
  //         );
  //       },
  //     )..show();
  //   }
  // }

  login(
    String mobileNumber,
    String password,
  ) async {
    if (mobileNumber.isEmpty || password.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Enter Required Fields',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      )..show();
    }
    // else if (password.length < 6) {
    //   AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.error,
    //     animType: AnimType.rightSlide,
    //     title: 'Password must be at least 6 characters long',
    //     btnOkColor: MyTheme.buttonColor,
    //     btnOkOnPress: () {},
    //   )..show();
    //   return;
    // }
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
        return;
      }
      final Map<String, dynamic> reqBody = {
        'mobileNumber': mobileNumber,
        'password': password,
      };

      final response = await post(
        Uri.parse('https://poralekha-server-chi.vercel.app/auth/login'),
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
          btnOkText: 'OK',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ),
            );
          },
        ).show();
        final data = json.decode(response.body);
        final String authToken = data['token'];
        print(authToken);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', authToken);
      } else if (response.statusCode == 409) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'User Not Found',
          desc: 'Please use right mobile number',
          btnOkText: 'OK',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {},
        ).show();
      } else if (response.statusCode == 400) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'Incorrect password',
          btnOkText: 'OK',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {},
        ).show();
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
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1,
                vertical: screenHeight * 0.05,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/poralekha-splash-screen-logo.png",
                    width: screenWidth * 0.4,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Phone",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CommonTextField(
                    controller: emailController,
                    text: "Phone",
                    obscure: false,
                    suffixIcon: const Icon(IconsaxBold.sms),
                    textInputType: TextInputType.phone,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgetPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password ?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7E59FD),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  RoundedButton(
                    title: "Login",
                    width: double.infinity,
                    onTap: () {
                      login(
                        emailController.text.toString(),
                        passwordController.text.toString(),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.04,
                            color: const Color(0xFF7E59FD),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: AlertDialog(
                    backgroundColor: Colors.transparent,
                    content: SpinKitCircle(color: Colors.white, size: 50.0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

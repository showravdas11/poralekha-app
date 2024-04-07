import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/screens/ForgetPassword/ForgetPassword.dart';
import 'package:poralekha_app/screens/OtpScreen/OtpScreen.dart';
import 'package:poralekha_app/screens/signUp/SignUpScreen.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the OTP screen

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

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  void _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  login(String input, String password) async {
    setState(() {
      isLoading = true;
    });

    if (input.isEmpty || password.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Enter Required Fields',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      )..show();

      setState(() {
        isLoading = false;
      });
    } else {
      UserCredential? userCredential;
      try {
        if (_isEmail(input)) {
          userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: input, password: password);
        }
        // If not, assume it's a phone number
        else if (_isMobile(input)) {
          // Perform phone number authentication
          final PhoneVerificationCompleted verificationCompleted =
              (PhoneAuthCredential phoneAuthCredential) async {
            userCredential = await FirebaseAuth.instance
                .signInWithCredential(phoneAuthCredential);
          };

          final PhoneVerificationFailed verificationFailed =
              (FirebaseAuthException authException) {
            print(
                'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
          };

          final PhoneCodeSent codeSent =
              (String verificationId, int? resendToken) async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId: verificationId),
              ),
            );
          };

          final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
              (String verificationId) {};

          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: input,
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
            timeout: Duration(seconds: 5),
          );
        } else {
          // Invalid input
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            title: 'Invalid Email or Mobile Number',
            btnOkColor: MyTheme.buttonColor,
            btnOkOnPress: () {},
          )..show();
        }

        // Remaining login logic remains the same...
      } on FirebaseAuthException catch (ex) {
        // Handle authentication exceptions
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: ex.message.toString(),
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {},
        )..show();
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  bool _isEmail(String input) {
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailRegex).hasMatch(input);
  }

  bool _isMobile(String input) {
    String mobileRegex = (r'^\+?(88)?0?1[3456789][0-9]{8}\b');
    return RegExp(mobileRegex).hasMatch(input);
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
                      "Email / Phone Number",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CommonTextField(
                    controller: emailController,
                    text: "Email / Phone Number",
                    obscure: false,
                    suffixIcon: const Icon(IconsaxBold.sms),
                    textInputType: TextInputType.text,
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

import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:poralekha_app/MainScreen/MainScreen.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/screens/ClassList/ClassListScreen.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  OtpScreen({
    Key? key,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  late String name;
  late String address;
  late String gender;
  late int age;
  late String _mobileNumber;
  BuildContext? dialogContext;
  Timer? _timer;
  int _countdown = 300;
  bool _isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isTimerRunning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

//---------------------Resend otp api call--------------------------//

  Future<void> resendOtp(String mobileNumber, String security) async {
    try {
      final Map<String, dynamic> resendBody = {
        "security": security,
        "mobileNumber": mobileNumber,
      };

      final response = await post(
        Uri.parse('https://poralekha-server-chi.vercel.app/otp/resend-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(resendBody),
      );

      if (response.statusCode == 200) {
        print("Otp Send");
      } else {
        print("Otp Not Send");
        print("status code ${response.statusCode}");
        print("My bodyrr ${response.body}");
      }
    } catch (e) {}
  }

//--------------------Otp api call----------------------//
  Future<void> otpCode(String otp, String mobileNumber) async {
    try {
      final Map<String, dynamic> reqBody = {
        "otp": otp,
        "mobileNumber": mobileNumber,
      };

      final response = await post(
        Uri.parse('https://poralekha-server-chi.vercel.app/otp/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(reqBody),
      );

      print("status code ${response.statusCode}");
      print("My bodyrr ${response.body}");

      if (response.statusCode == 200) {
        Navigator.pop(dialogContext!);

        final data = json.decode(response.body);
        final String authToken = data['token'];
        final Map<String, dynamic> user = data['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', authToken);
        await prefs.setString("name", user["name"]);
        await prefs.setString("mobileNumber", user["mobileNumber"]);
        await prefs.setBool("isAdmin", user["isAdmin"]);
        await prefs.setString("address", user["address"] ?? "");
        await prefs.setInt("age", user["age"] ?? 0);
        await prefs.setString("class", user["class"] ?? "");
        await prefs.setString("gender", user["gender"] ?? "");
        await prefs.setString("img", user["img"] ?? "");
        await prefs.setString("role", user["role"]);
        await prefs.setBool("isVerified", user["isVerified"]);
        await prefs.setString("_id", user["_id"]);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          title: 'Now you go to HomeScreen',
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

        if (user["class"] == null || user["class"] == "") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassListScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
          );
        }
      } else {}
    } catch (e) {
      print(e.toString());
      // Handle other exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/otp.png",
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.2,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Enter the OTP sent to your mobile",
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
                CommonTextField(
                  controller: otpController,
                  text: "Enter OTP",
                  textInputType: TextInputType.phone,
                  obscure: false,
                  suffixIcon: Icon(Icons.lock),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Timer: ${(_countdown ~/ 60).toString()}:${(_countdown % 60).toString()}"),
                    Row(
                      children: [
                        Text(
                          "Didn't receive OTP?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        InkWell(
                          onTap: _isTimerRunning
                              ? null
                              : () {
                                  setState(() {
                                    _isTimerRunning = true; // Enable timer
                                    _countdown = 300; // Reset countdown
                                    startTimer(); // Start timer
                                    // Call resendOtp function with the mobile number and security parameter
                                    resendOtp(widget.mobileNumber, "qwerty");
                                  });
                                },
                          child: Text(
                            "Resend",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: screenWidth * 0.04,
                              color: _isTimerRunning
                                  ? Colors.grey
                                  : MyTheme.buttonColor,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.04),
                RoundedButton(
                  title: "Submit",
                  onTap: () {
                    if (otpController.text.trim().isEmpty) {
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
                      otpCode(otpController.text.trim(), widget.mobileNumber);
                    }
                  },
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:poralekha_app/MainScreen/MainScreen.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
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

  Future<void> otpCode(String otp, String mobileNumber) async {
    print("Mobile Number: $mobileNumber");
    print("OTP: $otp");
    try {
      final Map<String, dynamic> reqBody = {
        "otp": otp,
        "mobileNumber": mobileNumber,
      };

      final response = await post(
        Uri.parse('https://poralekha-server-chi.vercel.app/otp/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );

      print("status code ${response.statusCode}");
      print("My bodyrr ${response.body}");

      if (response.statusCode == 200) {
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
        // final data = json.decode(response.body);
        // final String authToken = data['token'];
        // print(authToken);

        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('authToken', authToken);
      } else if (response.statusCode == 400) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'invalid otp',
          btnOkText: 'OK',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {},
        ).show();
      } else if (response.statusCode == 409) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'Time Error',
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
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/otp.png",
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              "Enter the OTP sent to your mobile",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CommonTextField(
              controller: otpController,
              text: "Enter OTP",
              textInputType: TextInputType.phone,
              obscure: false,
              suffixIcon: Icon(Icons.lock),
            ),
            SizedBox(height: 20),
            RoundedButton(
              title: "Submit",
              onTap: () {
                otpCode(otpController.text.trim(), widget.mobileNumber);
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poralekha_app/MainScreen/MainScreen.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();

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
              onTap: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otpController.text,
                  );
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ),
                  );
                } catch (ex) {
                  print("Error: $ex");
                  // Handle verification failure
                }
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

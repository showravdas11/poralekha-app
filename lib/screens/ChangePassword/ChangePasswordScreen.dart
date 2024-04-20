import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/MainScreen/MainScreen.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key});

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  final TextEditingController CurrentPassController = TextEditingController();
  final TextEditingController NewPassController = TextEditingController();
  final TextEditingController ConfirmPassController = TextEditingController();

  Future<void> ChangePassword(
      String currentPassword, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    try {
      final Map<String, dynamic> changePassBody = {
        "oldPassword": currentPassword,
        "newPassword": newPassword,
      };

      String apiUrl =
          'https://poralekha-server-chi.vercel.app/auth/change-password';
      var response = await put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(changePassBody),
      );

      if (response.statusCode == 200) {
        print("Password changed");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          title: 'Your password has been reset successfully',
          btnOkText: 'Continue',
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
      } else if (response.statusCode == 400) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'Incorrect Current Password',
          btnOkText: 'OK',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {},
        ).show();
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${response.body}');
        print('Not Changed');
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: MyTheme.canvousColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                "Change Your Password",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            CommonTextField(
              controller: CurrentPassController,
              text: "Current Password",
              textInputType: TextInputType.visiblePassword,
              obscure: true,
            ),
            SizedBox(
              height: 20,
            ),
            CommonTextField(
              controller: NewPassController,
              text: "New Password",
              textInputType: TextInputType.visiblePassword,
              obscure: true,
            ),
            SizedBox(
              height: 20,
            ),
            CommonTextField(
              controller: ConfirmPassController,
              text: "Confirm New Password",
              textInputType: TextInputType.visiblePassword,
              obscure: true,
            ),
            SizedBox(
              height: 20,
            ),
            RoundedButton(
                title: "Change My Password",
                onTap: () {
                  if (CurrentPassController.text.trim().isEmpty ||
                      NewPassController.text.trim().isEmpty ||
                      ConfirmPassController.text.trim().isEmpty) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: 'Enter Required Fields',
                      btnOkColor: MyTheme.buttonColor,
                      btnOkOnPress: () {},
                    ).show();
                  } else if (ConfirmPassController.text.trim() !=
                      NewPassController.text.trim()) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: "Password and Confirm password don't match",
                      btnOkColor: MyTheme.buttonColor,
                      btnOkOnPress: () {},
                    ).show();
                  } else {
                    ChangePassword(CurrentPassController.text.trim(),
                        NewPassController.text.trim());
                  }
                },
                width: double.infinity)
          ],
        ),
      ),
    );
  }
}

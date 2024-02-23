import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/common/RoundedButton.dart';

class SuccessfullScreen extends StatefulWidget {
  const SuccessfullScreen({super.key});

  @override
  State<SuccessfullScreen> createState() => _SuccessfullScreenState();
}

class _SuccessfullScreenState extends State<SuccessfullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("assets/images/success.gif"),
          ),
          Text(
            "+01808808880",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Your payment has been completed successfully.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RoundedButton(
                title: "Done",
                onTap: () {
                  Get.to(const SuccessfullScreen());
                },
                width: double.infinity),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/screens/Payment/Successfull/SuccessfullScreen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int? _selectedPaymentIndex;

  final paymentLabels = [
    "bKash",
    "Nagad",
  ];

  final paymentImage = [
    "assets/images/BKash-bKash-Logo.wine.png",
    "assets/images/Nagad-Logo.wine.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 248, 255),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Choose your payment method".tr,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: paymentLabels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(paymentLabels[index].tr),
                  leading: Radio<int>(
                    value: index,
                    groupValue: _selectedPaymentIndex,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentIndex = value;
                      });
                    },
                  ),
                  trailing: SizedBox(
                    height: 50,
                    width: 70,
                    child: Image.asset(
                      paymentImage[index], // Corrected the image index
                      fit: BoxFit
                          .contain, // Ensure the image fits within the specified size
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 0.5,
                  color: Colors.grey.shade300,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RoundedButton(
                title: "Pay",
                onTap: () {
                  Get.to(SuccessfullScreen());
                },
                width: double.infinity),
          )
        ],
      ),
    );
  }
}

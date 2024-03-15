import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/common/RoundedButton.dart';

class SuccessfulScreen extends StatefulWidget {
  const SuccessfulScreen({super.key});

  @override
  State<SuccessfulScreen> createState() => _SuccessfulScreenState();
}

class _SuccessfulScreenState extends State<SuccessfulScreen> {

  List<String> mobileNumbers = [];

  @override
  void initState() {
    super.initState();
    fetchMobileNumbers();
  }

  Future<void> fetchMobileNumbers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('contact')
          .limit(1)
          .get(); // Limit the query to only one document
      List<dynamic> numbers =
      querySnapshot.docs.first.get('mobileNumbers'); // Retrieve mobileNumbers from the first document
      print(numbers.cast<String>().toList());
      setState(() {
        mobileNumbers = numbers.cast<String>().toList();
      });
    } catch (e) {
      print('Error fetching mobile numbers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("assets/images/done.gif"),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Your payment has been completed successfully.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Column(
            children: mobileNumbers.map((number) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      number,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RoundedButton(
                title: "Done",
                onTap: () {
                  Navigator.pop(context);
                },
                width: double.infinity),
          ),
        ],
      ),
    );
  }
}

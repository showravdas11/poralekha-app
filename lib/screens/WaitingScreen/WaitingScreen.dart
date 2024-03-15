import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/contact.png",
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Please contact the admin panel to verify. Otherwise, you won't get anything from this app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.w600
                ), // Adjust text size as per screen width
              ),
            ),
            const SizedBox(
              height: 20,
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
          ],
        ),
      ),
    );
  }
}

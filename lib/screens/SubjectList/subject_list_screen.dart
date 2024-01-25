import 'package:flutter/material.dart';

class SubjectListScreen extends StatelessWidget {
  SubjectListScreen({Key? key});

  List<String> subs = [
    "Bangla 1st",
    "Bangla 2nd",
    "English",
    "English Grammar",
    "Mathematics",
    "Physics",
    "Chemistry",
    "Biology",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Class Subject",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: subs.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 126, 89, 253),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  // BoxShadow(
                  //   color: Colors.grey.withOpacity(0.5),
                  //   spreadRadius: 1,
                  //   blurRadius: 10,
                  // ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subs[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/SubjectList/ChapterList/TutorVideoScreen.dart';

class TutorVideoOnline extends StatelessWidget {
  const TutorVideoOnline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("subjects")
          .doc("adqxripumg9O6ZsUHjTL")
          .collection("chapters")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final tutorialDocs = snapshot.data!.docs;
          return Column(
            children: tutorialDocs.map((tutorialDoc) {
              final tutorials = tutorialDoc['topics'] as List<dynamic>;
              return Column(
                children: tutorials.map((tutor) {
                  return Container(
                    height: 65,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/youtubegif.gif',
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                //'${tutor['tutorName']} Tutorials',
                                tutor['tutorName'],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(const TutorVideoScreen());
                          },
                          child: const Text("Watch Now"),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        }
      },
    );
  }
}

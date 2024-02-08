import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportantTopicScreen extends StatelessWidget {
  const ImportantTopicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("subjects")
          .doc("A3oHaj9vWr36rboPvOrl")
          .collection("chapters")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final chapters = snapshot.data!.docs;
          return Column(
            children: chapters.map((chapterDoc) {
              final topics = chapterDoc['topics'] as List<dynamic>;
              return Column(
                children: topics.map((topic) {
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
                                'assets/images/Bookgif.gif',
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                topic['topicName'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            String animationUrl = topic['animationUrl'];
                            Get.defaultDialog(
                              title: 'Animation',
                              titleStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              titlePadding: const EdgeInsets.only(top: 10),
                              content: SizedBox(
                                height: 150,
                                width: 270,
                                child: Image.network(
                                  animationUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          child: const Text("Click Here"),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/PDFViewer/pdf_viewer.dart';
import 'package:poralekha_app/screens/SubjectList/ChapterList/TutorVideoScreen.dart';

class ChapterTopicScreen extends StatelessWidget {
  ChapterTopicScreen({Key? key}) : super(key: key);

  List<String> topics = [
    "Topic 1",
    "Topic 2",
    "Topic 3",
  ];

  List<String> topicstu = [
    "Online Tutorials 1",
    "Online Tutorials 2",
    "Online Tutorials 3",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ChapterTopic",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Get.to(const PdfViewer());
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 126, 89, 253),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(10),
                  child: const Center(
                    child: Text(
                      'PDF Book',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Important Topics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
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
                          //spreadRadius: 1,
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
                                'assets/images/Bookgif.gif', // Replace with the actual path to your image
                                width: 40, // Adjust width as needed
                                height: 40, // Adjust height as needed
                              ),
                              const SizedBox(width: 10),
                              Text(
                                topic,
                                style: const TextStyle(
                                  //color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'Animation',
                              titleStyle: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              titlePadding: const EdgeInsets.only(top: 20),
                              content: Container(
                                height: 150,
                                width: 250,
                                child: Image.asset(
                                  'assets/images/chinese-beaver.gif', // Replace with the actual path to your GIF
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Click Here",
                            // style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Online Tutorials',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: topicstu.map((topictu) {
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
                          //spreadRadius: 1,
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
                                'assets/images/youtubegif.gif', // Replace with the actual path to your image
                                width: 40, // Adjust width as needed
                                height: 40, // Adjust height as needed
                              ),
                              const SizedBox(width: 10),
                              Text(
                                topictu,
                                style: const TextStyle(
                                  //color: Colors.white,
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
                          child: const Text(
                            "Watch Now",
                            // style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

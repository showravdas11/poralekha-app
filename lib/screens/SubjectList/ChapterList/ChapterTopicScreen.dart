import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChapterTopicScreen extends StatelessWidget {
  ChapterTopicScreen({Key? key}) : super(key: key);

  List<String> topics = [
    "Topic 1",
    "Topic 2",
    "Topic 3",
    "Topic 4",
    "Topic 5",
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
                  // Handle button press
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 126, 89, 253),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Container(
                  width: 180,
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
              const Center(
                child: Text(
                  'Important Topics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: topics.map((topic) {
                  return Container(
                    height: 65,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 126, 89, 253),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            topic,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'Animation',
                                titleStyle: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
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
                            child: Text(
                              "See Details",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'Our Tutorials',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

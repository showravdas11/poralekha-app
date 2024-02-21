import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportantTopicScreen extends StatefulWidget {
  final String documentId;
  final List<dynamic> topics;
  const ImportantTopicScreen({
    Key? key,
    required this.documentId,
    required this.topics,
  }) : super(key: key);

  @override
  State<ImportantTopicScreen> createState() => _ImportantTopicScreenState();
}

class _ImportantTopicScreenState extends State<ImportantTopicScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.topics.map((topic) {
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
                    // Image.asset(
                    //   'assets/images/Bookgif.gif',
                    //   width: 40,
                    //   height: 40,
                    // ),
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
                  // String animationUrl = topic['animationUrl'];
                  String? animationUrl = topic['animationUrl'];
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
                        animationUrl!,
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
  }
}

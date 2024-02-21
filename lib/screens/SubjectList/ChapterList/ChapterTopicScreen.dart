import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/PDFViewer/pdf_viewer.dart';
import 'package:poralekha_app/screens/SubjectList/ChapterList/ImportantTopicsScreen.dart';
import 'package:poralekha_app/screens/SubjectList/ChapterList/TutorVideoOnline.dart';
import 'package:poralekha_app/screens/SubjectList/ChapterList/TutorVideoScreen.dart';

class ChapterTopicScreen extends StatefulWidget {
  const ChapterTopicScreen({Key? key}) : super(key: key);

  @override
  _ChapterTopicScreenState createState() => _ChapterTopicScreenState();
}

class _ChapterTopicScreenState extends State<ChapterTopicScreen> {
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
                  // Get.to(const PdfViewer());
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
              const ImportantTopicScreen(),
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
              TutorVideoOnline(),
            ],
          ),
        ),
      ),
    );
  }
}

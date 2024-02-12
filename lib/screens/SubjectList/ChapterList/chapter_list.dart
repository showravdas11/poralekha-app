import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/PDFViewer/pdf_viewer.dart';
import 'package:poralekha_app/screens/SubjectList/ChapterList/ChapterTopicScreen.dart';

class ChapterListScreen extends StatefulWidget {
  const ChapterListScreen({Key? key}) : super(key: key);

  @override
  _ChapterListScreenState createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _chaptersStream;

  @override
  void initState() {
    super.initState();
    _chaptersStream = FirebaseFirestore.instance
        .collection("subjects")
        .doc("adqxripumg9O6ZsUHjTL")
        .collection("chapters")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chapter List",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _chaptersStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            List<String> chapters = snapshot.data!.docs
                .map((doc) => doc['name'] as String)
                .toList();

            return ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Get.to(const PdfViewer());
                    Get.to(ChapterTopicScreen());
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 126, 89, 253),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
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
                          chapters[index],
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

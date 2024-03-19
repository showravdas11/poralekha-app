import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/SubjectList/ChapterList/ChapterTopicScreen.dart';

class ChapterListScreen extends StatefulWidget {
  final String subjectId;

  // Update the constructor to properly initialize subjectId
  const ChapterListScreen({
    Key? key,
    required this.subjectId,
  }) : super(key: key);

  @override
  _ChapterListScreenState createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _chaptersStream;

  @override
  void initState() {
    super.initState();
    _chaptersStream = FirebaseFirestore.instance
        .collection('subjects')
        .doc(widget.subjectId) // Use widget.subjectId here
        .collection('chapters')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chapters".tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No chapters available'.tr),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final documentId = snapshot.data!.docs[index].id;
                final chapter = snapshot.data!.docs[index].data();
                return GestureDetector(
                  onTap: () {
                    Get.to(ChapterTopicScreen(
                      documentId: documentId,
                      chapter: chapter,
                    ));
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
                        Expanded(
                          child: Text(
                            chapter['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Text(
                        //   chapters[index]['pdfLink'],
                        //   style: const TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 18,
                        //   ),
                        // ),
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

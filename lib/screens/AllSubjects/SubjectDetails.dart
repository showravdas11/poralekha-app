import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/AddChapter/Add_chapter.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/screens/AddSubjects/AddSubjects.dart';
import 'package:poralekha_app/screens/AllSubjects/EditSubject.dart';
import 'package:poralekha_app/screens/SubjectList/ChapterList/ChapterTopicScreen.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class SubjectDetails extends StatefulWidget {
  final String documentId;
  final String className;
  final String subjectName;

  const SubjectDetails(
      {Key? key,
      required this.documentId,
      required this.className,
      required this.subjectName});

  @override
  State<SubjectDetails> createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  late Stream<QuerySnapshot> _chapterStream;

  @override
  void initState() {
    super.initState();

    _chapterStream = FirebaseFirestore.instance
        .collection('subjects')
        .doc(widget.documentId)
        .collection('chapters')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = AppBar().preferredSize.height;
    final screenHeight = screenSize.height - appBarHeight;
    final screenWidth = screenSize.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Subject Details".tr,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                ),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('subjects')
                      .doc(widget.documentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {}
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final subjectData =
                        snapshot.data?.data() as Map<String, dynamic>?;

                    return Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      height: Get.height * 0.20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${"Subject".tr}: ${subjectData?['name'] ?? 'N/A'}"
                                .tr,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "${"Class".tr}: ${subjectData?['class'] ?? 'N/A'}",
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(EditSubject(
                                  documentId: widget.documentId,
                                  subjectName: subjectData?['name'] ?? 'N/A',
                                  className: subjectData?['class'] ?? 'N/A'));
                            },
                            child: const Text("Update Subject"),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Chapter List".tr,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: screenHeight * 0.02),
              StreamBuilder<QuerySnapshot>(
                stream: _chapterStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final chapters = snapshot.data?.docs ?? [];
                  return Column(
                    children: chapters.map((chapter) {
                      final chapterData =
                          chapter.data() as Map<String, dynamic>;
                      final chapterName = chapterData['name'] ?? '';

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.03),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$chapterName",
                                    style: TextStyle(fontSize: screenWidth * 0.04),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyTheme.buttonColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.01,
                                      horizontal: screenWidth * 0.02),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.02),
                                  ),
                                ),
                                onPressed: () {
                                  Get.to(ChapterTopicScreen(
                                    documentId: chapter.id,
                                    chapter: chapterData,
                                  ));
                                },
                                child: Text(
                                  "Show Details".tr,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddChapterScreen(
                      documentId: widget.documentId,
                      className: widget.className,
                      subjectName: widget.subjectName
                  ),
            ),
          );
        },
        backgroundColor: Colors.white,
        foregroundColor: MyTheme.buttonColor,
        child: Icon(
          Icons.add,
          size: screenWidth * 0.1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.1),
        ),
      ),
    );
  }
}

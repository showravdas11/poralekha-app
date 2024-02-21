import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poralekha_app/screens/AddChapter/Add_chapter.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/screens/AddSubjects/AddSubjects.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class SubjectDetails extends StatefulWidget {
  final String subjectId;

  const SubjectDetails({Key? key, required this.subjectId});

  @override
  State<SubjectDetails> createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  late Stream<DocumentSnapshot> _subjectStream;
  late Stream<QuerySnapshot> _chapterStream;
  late Map<String, dynamic> _subjectData;
  late String _docId;

  @override
  void initState() {
    super.initState();
    _subjectStream = FirebaseFirestore.instance
        .collection('subjects')
        .doc(widget.subjectId)
        .snapshots();

    _chapterStream = FirebaseFirestore.instance
        .collection('subjects')
        .doc(widget.subjectId)
        .collection('chapters')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<DocumentSnapshot>(
      stream: _subjectStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(
            child: Text("No Data Found"),
          );
        }
        _subjectData = snapshot.data!.data() as Map<String, dynamic>;
        _docId = snapshot.data!.id;

        return Scaffold(
          appBar: CustomAppBar(
            title: "Subject Details",
            leadingOnPressed: () {
              Navigator.pop(context);
            },
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
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
                          "Subject Name: ${_subjectData['name'] ?? ''}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Class: ${_subjectData['class'] ?? ''}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Chapter List",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _chapterStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$chapterName",
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                            fontFamily: "FontMain"),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyTheme.buttonColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          horizontal: screenWidth * 0.02),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.02),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Handle button press
                                    },
                                    child: Text(
                                      "Show Details",
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.04),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddChapterScreen(
                      subjectData: _subjectData, docId: _docId),
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
              borderRadius: BorderRadius.circular(screenWidth * 0.10),
            ),
          ),
        );
      },
    );
  }
}

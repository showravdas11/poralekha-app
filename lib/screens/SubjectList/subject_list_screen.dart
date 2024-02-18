import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/SubjectList/ChapterList/chapter_list.dart';

class SubjectListScreen extends StatefulWidget {
  final String className;

  const SubjectListScreen({Key? key, required this.className})
      : super(key: key);

  @override
  _SubjectListScreenState createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _subjectsStream;

  @override
  void initState() {
    super.initState();
    _subjectsStream = FirebaseFirestore.instance
        .collection("subjects")
        .where('class', isEqualTo: widget.className)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Class Subject",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _subjectsStream,
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

            List<String> subjects = snapshot.data!.docs
                .map((doc) => doc['name'] as String)
                .toList();

            return ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Handle the onTap event
                    String selectedSubjectId = snapshot.data!.docs[index].id;
                    Get.to(ChapterListScreen(subjectId: selectedSubjectId));
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
                        //   blurRadius: 1,
                        // ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subjects[index],
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

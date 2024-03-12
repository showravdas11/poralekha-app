import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/SubjectList/ChapterList/chapter_list.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({Key? key}) : super(key: key);

  @override
  _SubjectListScreenState createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _subjectsStream;
  List<Color> _tileColors = [
    Color(0xFFFE7B33),
    Color(0xFF616FEA),
    Color(0xFF9736E5),
    Color(0xFF3BBDF9),
    Color(0xFF3DC88A),
    Color(0xFFE84D51),
    // Add more colors as needed
  ];

  @override
  void initState() {
    super.initState();
    loadSubjectList();
  }

  void loadSubjectList() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final className = userData.get('class') as String;
      setState(() {
        _subjectsStream = FirebaseFirestore.instance
            .collection("subjects")
            .where('class', isEqualTo: className)
            .snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Subjects".tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

            List<String> subjects = snapshot.data?.docs
                    .map((doc) => doc['name'] as String)
                    .toList() ??
                [];

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.5,
              ),
              itemCount: subjects.length,
              itemBuilder: (BuildContext context, int index) {
                // Get the color for the current tile
                Color tileColor = _tileColors[index % _tileColors.length];
                return GestureDetector(
                  onTap: () {
                    // Handle the onTap event
                    String selectedSubjectId = snapshot.data!.docs[index].id;
                    Get.to(ChapterListScreen(subjectId: selectedSubjectId));
                  },
                  child: Card(
                    color: tileColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage('assets/images/subsbg1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            subjects[index],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
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

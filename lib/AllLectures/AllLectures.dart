import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/widgets/LecturesCard.dart';

class AllLectureScreen extends StatefulWidget {
  const AllLectureScreen({super.key});

  @override
  State<AllLectureScreen> createState() => _AllLectureScreenState();
}

class _AllLectureScreenState extends State<AllLectureScreen> {
  late Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance.collection('lecture').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        title: "All Lectures",
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.01),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: _usersStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Something Went Wrong"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text("No Data Found"),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final lectureData = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        final documentId = snapshot.data!.docs[index].id;
                        // print("my document id ${documentId}");

                        final String state = lectureData["state"];

                        return Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.01),
                          child: LectureCard(
                            lectureData: lectureData,
                            documentId: documentId,
                            screen: "admin",
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

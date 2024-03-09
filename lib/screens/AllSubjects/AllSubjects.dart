import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/screens/AddSubjects/AddSubjects.dart';
import 'package:poralekha_app/screens/AllSubjects/SubjectDetails.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class AllSubjectsScreen extends StatefulWidget {
  const AllSubjectsScreen({Key? key});

  @override
  State<AllSubjectsScreen> createState() => _AllSubjectsScreenState();
}

class _AllSubjectsScreenState extends State<AllSubjectsScreen> {
  late Stream<QuerySnapshot> _allSubjectStream;

  @override
  void initState() {
    super.initState();
    _allSubjectStream =
        FirebaseFirestore.instance.collection('subjects').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: "All subjects".tr,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _allSubjectStream,
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
                      var subjectData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      final documentId = snapshot.data!.docs[index].id;
                      return SubjectsCard(
                          subjectData: subjectData, documentId: documentId);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddSubjectsScreen()));
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
  }
}

class SubjectsCard extends StatelessWidget {
  const SubjectsCard({
    Key? key,
    required this.subjectData,
    required this.documentId,
  }) : super(key: key);

  final Map<String, dynamic> subjectData;
  final String documentId;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${"Subject".tr}: ${subjectData['name'].toString()}",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontFamily: "FontMain",
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Text(
                    "${"Class".tr}: ${subjectData['class'].toString()}",
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.buttonColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.01,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
              ),
              onPressed: () {
                Get.to(SubjectDetails(
                    documentId: documentId,
                    subjectName: subjectData['name'],
                    className: subjectData['class']));
              },
              child: Text(
                "Show Details".tr,
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
            )
          ],
        ),
      ),
    );
  }
}

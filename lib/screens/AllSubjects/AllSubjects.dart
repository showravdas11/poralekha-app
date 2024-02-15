import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/screens/AddSubjects/AddSubjects.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class AllSubjectsScreen extends StatefulWidget {
  const AllSubjectsScreen({super.key});

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
        title: "All Subject",
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
                      var subjecData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return SubjectsCard(subjecData: subjecData);
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class SubjectsCard extends StatelessWidget {
  const SubjectsCard({
    super.key,
    required this.subjecData,
  });

  final Map<String, dynamic> subjecData;

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Subject: ${subjecData['name'].toString()}",
                  style: TextStyle(
                      fontSize: screenWidth * 0.04, fontFamily: "FontMain"),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Text(
                  "Class: ${subjecData['class'].toString()}",
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
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Show Details",
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
            )
          ],
        ),
      ),
    );
  }
}

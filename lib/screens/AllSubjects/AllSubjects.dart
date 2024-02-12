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
    return Scaffold(
      appBar: CustomAppBar(
        title: "All Subject",
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
          size: 35,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subjecData['name'].toString(),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  subjecData['class'].toString(),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.buttonColor,
                foregroundColor: Colors.white,
                // minimumSize: Size(10, 40),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {},
              child: Text("Show Details"),
            )
          ],
        ),
      ),
    );
  }
}

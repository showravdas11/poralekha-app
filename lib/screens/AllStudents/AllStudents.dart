import 'package:flutter/material.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class AllStudent extends StatefulWidget {
  const AllStudent({Key? key});

  @override
  State<AllStudent> createState() => _AllStudentState();
}

class _AllStudentState extends State<AllStudent> {
  int studentCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCollectionLength();
  }

  Future<void> loadCollectionLength() async {
    try {
      FirebaseFirestore.instance.collection("students").count().get().then(
            (res) => {
              setState(() {
                studentCount = res.count ?? 0;
                isLoading = false;
              })
            },
        onError: (e) => print("Error completing: $e"),
      );
    } catch (e) {
      print('Error loading collection length: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "All Student",
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading ?
            Center(child: CircularProgressIndicator()) :
          Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                "Total Student: $studentCount",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




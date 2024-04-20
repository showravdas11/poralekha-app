// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poralekha_app/MainScreen/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poralekha_app/screens/WaitingScreen/WaitingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class ClassListScreen extends StatefulWidget {
  const ClassListScreen({Key? key}) : super(key: key);

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _classesStream;

  // Mapping of class names to corresponding image assets
  final Map<String, String> classImages = {
    'Class Ten': 'assets/images/rszten.png',
    'Class Nine': 'assets/images/rsznine.png',
    'Class Eight': 'assets/images/rszeight.png',
    'Class Seven': 'assets/images/rszseven.png',
    'Class Six': 'assets/images/rszsix.png',
    'Class Five': 'assets/images/rszfive.png',
  };

  @override
  void initState() {
    super.initState();
    _classesStream = FirebaseFirestore.instance
        .collection("classes")
        .orderBy('serial')
        .snapshots();
  }

  void updateClassInDatabase(String selectedClass) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');
      print("my authToken${authToken}");

      final Map<String, dynamic> selectClassBody = {
        'class': selectedClass,
      };
      String apiUrl =
          'https://poralekha-server-chi.vercel.app/auth/select-class';

      final response = await put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(selectClassBody),
      );
      if (response.statusCode == 200) {
        print('Class updated successfully.');
        await prefs.setString('class', selectedClass);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        print('Failed to update class. Status code: ${response.statusCode}');
        print('Failed to update class. Status Body: ${response.body}');
      }
    } catch (error) {
      print("Error updating class: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Select Your Class".tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: _classesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<String> classNames =
              snapshot.data!.docs.map((doc) => doc['name'] as String).toList();

          snapshot.data!.docs.map((doc) => print(doc));
          print(classNames);

          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ),
              shrinkWrap: true,
              itemCount: classNames.length,
              itemBuilder: (BuildContext context, int index) {
                String className = classNames[index].tr;
                String imageAsset = classImages[className] ??
                    ''; // Retrieve corresponding image asset
                if (imageAsset.isEmpty) {
                  return SizedBox(); // If image asset not found, return an empty SizedBox
                }
                return GestureDetector(
                  onTap: () {
                    updateClassInDatabase(className);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(14, 0, 0, 0),
                          spreadRadius: 1,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            imageAsset,
                            width: screenWidth * 0.20,
                          ),
                          Text(
                            className,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poralekha_app/MainScreen/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user authentication

class ClassListScreen extends StatefulWidget {
  const ClassListScreen({Key? key}) : super(key: key);

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _classesStream;

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
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is logged in
      if (user != null) {
        // Update the user's document in the Firestore database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'class': selectedClass});
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (error) {
      // Handle any errors that occur during the update process
      print("Error updating class: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
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

          List<String> imgData =
              snapshot.data!.docs.map((doc) => doc['img'] as String).toList();
          List<String> name =
              snapshot.data!.docs.map((doc) => doc['name'] as String).toList();

          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ),
              shrinkWrap: true,
              itemCount: imgData.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    String selectedClass = name[index];
                    updateClassInDatabase(selectedClass);
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
                          Image.network(
                            imgData[index],
                            width: screenWidth * 0.20,
                          ),
                          Text(
                            name[index].tr,
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

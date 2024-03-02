import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/Home/My_Drawer_Header.dart';
import 'package:poralekha_app/screens/Home/My_Drawer_list.dart';
import 'package:poralekha_app/screens/AllStudents/AllStudents.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:poralekha_app/widgets/HomeBanner.dart';
import 'package:poralekha_app/widgets/LecturesCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState(documentId: '');
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRunningSelected = true;
  late Stream<QuerySnapshot> _usersStream;

  final String documentId;

  _HomeScreenState({required this.documentId});

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance.collection('lecture').snapshots();
  }

  void loadSubjectList() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove elevation
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.data() == null) {
                return Text('User data not found');
              }

              // Extract user data
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final String userProfileImageUrl =
                  userData['profileImageUrl'] ?? '';
              final String userName = userData['name'] ?? '';
              final String userClass = userData['class'] ?? '';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: userProfileImageUrl.isNotEmpty
                          ? NetworkImage(userProfileImageUrl)
                          : AssetImage(
                                  'assets/images/default_profile_image.png')
                              as ImageProvider,
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87), // Adjust text color
                        ),
                        Text(
                          userClass,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey), // Adjust text color
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeBanner(),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: Text(
                  "Class Lectures",
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015,
                    horizontal: screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isRunningSelected = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRunningSelected
                            ? MyTheme.buttonColor
                            : MyTheme.buttonColor.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                        ),
                      ),
                      child: Text(
                        "Running",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isRunningSelected = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRunningSelected
                            ? MyTheme.buttonColor.withOpacity(0.6)
                            : MyTheme.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                        ),
                      ),
                      child: Text(
                        "Upcoming",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              StreamBuilder(
                stream: _usersStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something Went Wrong"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No Data Found"),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final lectureData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;

                      return isRunningSelected
                          ? Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.01),
                              child: LectureCard(
                                lectureData: lectureData,
                                documentId: documentId,
                                screen: "home",
                              ),
                            )
                          : SizedBox();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      drawer: const Drawer(
        backgroundColor: Color.fromARGB(255, 240, 248, 255),
        child: Column(
          children: [
            MyDrawerHeader(),
            MyDrawerList(),
          ],
        ),
      ),
    );
  }
}

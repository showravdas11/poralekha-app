import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/screens/Login/LoginScreen.dart';
import 'package:poralekha_app/screens/UpdateProfileScreen/UpdateProfile.dart';
import 'package:poralekha_app/widgets/ProfileHeadingSection.dart';
import 'package:poralekha_app/widgets/ProfileMenu.dart';
import 'package:poralekha_app/widgets/UtilitiesSection.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Stream<QuerySnapshot> _usersStream;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.canvousColor,
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: MyTheme.canvousColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Iconsax.arrow_left),
        ),
      ),
      body: StreamBuilder(
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

          var userData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: BottomCurveClipper(),
                      child: Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF5CB3FF),
                              Color(0xFF7E59FD)
                            ], // Example gradient colors
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 120, // Adjust the height as needed
                        width: 120, // Adjust the width as needed
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/images/user.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: HeadingSection(
                    title: "Personal Information",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProfileScreen(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ProfileMenu(
                  title: "Name",
                  subTitle: userData['name'],
                  icon: Icons.person,
                ),
                ProfileMenu(
                  title: "E-mail",
                  subTitle: userData['email'],
                  icon: Icons.email,
                ),
                ProfileMenu(
                  title: "Address",
                  subTitle: userData['address'],
                  icon: Icons.email,
                ),
                ProfileMenu(
                  title: "Age",
                  subTitle: userData['age'].toString(),
                  icon: Icons.email,
                ),
                // Add other ProfileMenu widgets as needed
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: HeadingSection(
                    title: "Utilities",
                    showActionButton: false,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                UtilitiesSection(
                  title: "Language",
                  subTitle:
                      "English", // You can populate this from Firestore if needed
                  icon: Iconsax.language_square5,
                  onPressed: () {
                    print("Hello");
                  },
                ),
                UtilitiesSection(
                  title: "Log Out",
                  subTitle: "Logout",
                  icon: Iconsax.logout,
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

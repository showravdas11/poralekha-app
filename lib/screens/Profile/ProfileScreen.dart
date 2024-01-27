import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/screens/Login/LoginScreen.dart';
import 'package:poralekha_app/screens/Profile/widget/ProfileHeadingSection.dart';
import 'package:poralekha_app/screens/Profile/widget/ProfileMenu.dart';
import 'package:poralekha_app/screens/Profile/widget/UtilitiesSection.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _userDataStream;

  @override
  void initState() {
    super.initState();
    _userDataStream =
        FirebaseFirestore.instance.collection("users").snapshots();
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
        stream: _userDataStream,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var userData = snapshot.data!.docs[index].data()
                      as Map<dynamic, dynamic>;
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
                                  backgroundImage:
                                      AssetImage("assets/images/user.png"),
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
                          child: HeadingSection(title: "Personal Information"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ProfileMenu(
                          title: "Name",
                          subTitle: userData["name"] ?? "N/A",
                          icon: Icons.person,
                        ),
                        ProfileMenu(
                          title: "E-mail",
                          subTitle: userData["email"] ?? "N/A",
                          icon: Icons.email,
                        ),
                        ProfileMenu(
                          title: "Address",
                          subTitle: userData["address"] ?? "N/A",
                          icon: Icons.location_city,
                        ),
                        ProfileMenu(
                          title: "Age",
                          subTitle: userData["age"].tos ?? "N/A",
                          icon: Icons.calendar_month,
                        ),
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
                          subTitle: "English",
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
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else {
              return Center(
                child: Text("No Data Found"),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
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

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

import '../Language/Language_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.canvousColor,
      appBar: AppBar(
        title: Text("Profile".tr),
        backgroundColor: MyTheme.canvousColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
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
                                child: const CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/user.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              HeadingSection(title: 'Personal Information'.tr),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ProfileMenu(
                          title: "Name",
                          subTitle: "${snapshot.data!.docs[index]["name"]}",
                          icon: Icons.person,
                        ),
                        ProfileMenu(
                          title: "E-mail",
                          subTitle: "${snapshot.data!.docs[index]["email"]}",
                          icon: Icons.email,
                        ),
                        ProfileMenu(
                          title: "Address",
                          subTitle: "${snapshot.data!.docs[index]["address"]}",
                          icon: Icons.location_city,
                        ),
                        ProfileMenu(
                          title: "Age",
                          subTitle: "${snapshot.data!.docs[index]["age"]}",
                          icon: Icons.calendar_month,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: HeadingSection(
                            title: "Utilities",
                            showActionButton: false,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        UtilitiesSection(
                          title: "Language".tr,
                          subTitle: Get.locale?.languageCode == 'en'
                              ? 'English'
                              : 'বাংলা',
                          icon: Iconsax.language_square5,
                          onPressed: () {
                            Get.bottomSheet(
                              const LanguageScreen(),
                            );
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
                                      builder: (context) =>
                                          const LoginScreen()));
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
              return const Center(
                child: Text("No Data Found"),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
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

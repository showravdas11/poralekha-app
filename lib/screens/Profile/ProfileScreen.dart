import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/screens/Login/LoginScreen.dart';
import 'package:poralekha_app/screens/Payment/PaymentScreen.dart';
import 'package:poralekha_app/screens/UpdateProfileScreen/UpdateProfile.dart';
import 'package:poralekha_app/widgets/ProfileHeadingSection.dart';
import 'package:poralekha_app/widgets/ProfileMenu.dart';
import 'package:poralekha_app/widgets/UtilitiesSection.dart';
import 'package:poralekha_app/theme/myTheme.dart';

import '../Language/Language_screen.dart';

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
        title: Text("Profile".tr),
        backgroundColor: MyTheme.canvousColor,
      ),
      body: StreamBuilder(
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

          var userData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;

          print("Data paisi${userData}");

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
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF7E59FD),
                              Color(0xFF5B37B7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: userData['profileImageUrl'] != null
                                  ? Image.network(
                                      userData['profileImageUrl'],
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "assets/images/default_profile_image.jpg", // Provide a default image asset
                                      fit: BoxFit.cover,
                                    ),
                            )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: HeadingSection(
                    title: "Personal Information".tr,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateProfileScreen(userData: userData),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ProfileMenu(
                  title: "Name".tr,
                  subTitle: userData['name'],
                  icon: Icons.person,
                ),
                ProfileMenu(
                  title: "E-mail".tr,
                  subTitle: userData['email'],
                  icon: Icons.email,
                ),
                ProfileMenu(
                  title: "Address".tr,
                  subTitle: userData['address'],
                  icon: Icons.location_on,
                ),
                ProfileMenu(
                  title: "Gender".tr,
                  subTitle: userData['gender'],
                  icon: Icons.male,
                ),
                ProfileMenu(
                  title: "Age".tr,
                  subTitle: userData['age'].toString(),
                  icon: Icons.calendar_today,
                ),
                // Add other ProfileMenu widgets as needed
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: HeadingSection(
                    title: "Utilities".tr,
                    showActionButton: false,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UtilitiesSection(
                  title: "Payment".tr,
                  subTitle: "Click Here".tr,
                  icon: Iconsax.card5,
                  onPressed: () {
                    Get.to(const PaymentScreen());
                  },
                ),
                UtilitiesSection(
                  title: "Language".tr,
                  subTitle:
                      Get.locale?.languageCode == 'en' ? 'English' : 'বাংলা',
                  icon: Iconsax.language_square5,
                  onPressed: () {
                    Get.bottomSheet(
                      const LanguageScreen(),
                    );
                  },
                ),

                UtilitiesSection(
                  title: "Log Out".tr,
                  subTitle: "Logout".tr,
                  icon: Iconsax.logout,
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
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

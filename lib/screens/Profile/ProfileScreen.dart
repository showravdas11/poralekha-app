import 'dart:convert';

import 'package:ficonsax/ficonsax.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/screens/ChangePassword/ChangePasswordScreen.dart';
import 'package:poralekha_app/screens/Login/LoginScreen.dart';
import 'package:poralekha_app/screens/Payment/PaymentScreen.dart';
import 'package:poralekha_app/screens/UpdateProfileScreen/UpdateProfile.dart';
import 'package:poralekha_app/widgets/ProfileHeadingSection.dart';
import 'package:poralekha_app/widgets/ProfileMenu.dart';
import 'package:poralekha_app/widgets/UtilitiesSection.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Language/Language_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? mobileNumber;
  String? address;
  String? gender;
  int? age;
  String? profileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    print("my token daw pls ${authToken}");
    String apiUrl = 'https://poralekha-server-chi.vercel.app/auth/me';
    // String bearerToken = 'authToken';
    // print('my bearer token${bearerToken}');

    try {
      var response = await get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print("my datatatatta paiaiai${data}");
        Map<String, dynamic> user = data["user"];
        setState(() {
          name = user['name'];
          mobileNumber = user['mobileNumber'];
          address = user['address'];
          gender = user['gender'];
          age = user['age'];
          profileImageUrl = user['img'];
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = AppBar().preferredSize.height;
    final screenHeight = screenSize.height - appBarHeight;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: MyTheme.canvousColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile".tr,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: MyTheme.canvousColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                              child: profileImageUrl != null &&
                                      profileImageUrl != ""
                                  ? Image.network(
                                      profileImageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "assets/images/person-placeholder.jpg",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
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
                            builder: (context) => UpdateProfileScreen(
                              userData: {
                                'name': name,
                                'mobileNumber': mobileNumber,
                                'address': address,
                                'gender': gender,
                                'age': age,
                              },
                              onUpdateProfile: fetchData,
                            ),
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
                    subTitle: name ?? '',
                    icon: IconsaxBold.user,
                  ),
                  ProfileMenu(
                    title: "Mobile Number".tr,
                    subTitle: mobileNumber ?? '',
                    icon: IconsaxBold.sms,
                  ),
                  ProfileMenu(
                    title: "Address".tr,
                    subTitle: address ?? '',
                    icon: IconsaxBold.location,
                  ),
                  ProfileMenu(
                    title: "Gender".tr,
                    subTitle: gender ?? '',
                    icon: IconsaxBold.man,
                  ),
                  ProfileMenu(
                    title: "Age".tr,
                    subTitle: age != null ? age.toString() : '',
                    icon: IconsaxBold.calendar,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: HeadingSection(
                      title: "Payment".tr,
                      showActionButton: false,
                    ),
                  ),
                  UtilitiesSection(
                    title: "Payment".tr,
                    subTitle: "Click Here".tr,
                    icon: IconsaxBold.card,
                    onPressed: () {
                      Get.to(const PaymentScreen());
                    },
                  ),
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
                  UtilitiesSection(
                    title: "Language".tr,
                    subTitle: Get.locale?.languageCode == 'en_US'
                        ? 'English'.tr
                        : 'বাংলা'.tr,
                    icon: IconsaxBold.language_square,
                    onPressed: () {
                      Get.bottomSheet(
                        const LanguageScreen(),
                      );
                    },
                  ),
                  UtilitiesSection(
                    title: "Change Password".tr,
                    subTitle: "Click Here".tr,
                    icon: IconsaxBold.password_check,
                    onPressed: () {
                      Get.to(const ChangePassScreen());
                    },
                  ),
                  UtilitiesSection(
                    title: "Log Out".tr,
                    subTitle: "Logout".tr,
                    icon: IconsaxBold.logout,
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('authToken');

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
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

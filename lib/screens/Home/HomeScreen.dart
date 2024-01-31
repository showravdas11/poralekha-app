import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:poralekha_app/screens/Home/My_Drawer_Header.dart';
import 'package:poralekha_app/screens/Home/My_Drawer_list.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:poralekha_app/widgets/HomeBanner.dart';
import 'package:poralekha_app/widgets/HomeCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRunningSelected = true;
  late Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance.collection('lecture').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Mina',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Class Five'.tr,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/profile.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              HomeBanner(),
              const SizedBox(
                height: 30,
              ),
              Center(
                  child: Text(
                "Lectures",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: "FontMain"),
              )),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: isRunningSelected
                          ? MyTheme.buttonColor
                          : MyTheme.buttonColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isRunningSelected = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          child: Text(
                            "Running",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: "FontMain"),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: isRunningSelected
                          ? MyTheme.buttonColor.withOpacity(0.6)
                          : MyTheme.buttonColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isRunningSelected = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          child: Text(
                            "Upcoming",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: "FontMain"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              HomeClassCard(
                name: "Bangla",
                Class: "Six",
                teacherName: "Karim sir",
              ),
              SizedBox(
                height: 10,
              ),
              HomeClassCard(
                name: "English",
                Class: "Six",
                teacherName: "Rahim Sir",
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

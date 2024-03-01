import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/screens/AddChapter/Add_chapter.dart';
import 'package:poralekha_app/screens/AllLectures/AllLectures.dart';
import 'package:poralekha_app/screens/AddLectures/AddLectures.dart';

import 'package:poralekha_app/screens/AllSubjects/AllSubjects.dart';
import 'package:poralekha_app/screens/ApproveUser/ApproveUser.dart';
import 'package:poralekha_app/screens/AllStudents/AllStudents.dart';
import 'package:poralekha_app/screens/count.dart';

class MyDrawerList extends StatelessWidget {
  const MyDrawerList({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Iconsax.user),
            title: Text("Approve User".tr),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ApproveUser()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined),
            title: Text("Manage Admin".tr),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddLectureScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.add_circle),
            title: Text("Add Lecture".tr),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddLectureScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.lamp),
            title: Text("All Students".tr),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AllStudent()));
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.lamp),
            title: Text("All lectures".tr),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllLectureScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.book),
            title: Text("All subjects".tr),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllSubjectsScreen()));
            },
          ),
        ],
      ),
    );
  }
}

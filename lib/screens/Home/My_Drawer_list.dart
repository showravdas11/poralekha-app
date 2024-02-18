import 'package:flutter/material.dart';
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
            title: const Text("Approve User"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ApproveUser()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined),
            title: const Text("Mange Admin"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddLectureScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.add_circle),
            title: const Text("Add Lecture"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddLectureScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.lamp),
            title: const Text("All Student"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllStudent()));
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.lamp),
            title: const Text("All lecture"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllLectureScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.book),
            title: const Text("All subject"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllSubjectsScreen()));
            },
          ),
        ],
      ),
    );
  }
}

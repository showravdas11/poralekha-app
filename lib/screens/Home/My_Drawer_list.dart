import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/screens/AllLectures/AllLectures.dart';
import 'package:poralekha_app/screens/AddLectures/AddLectures.dart';
import 'package:poralekha_app/screens/AllSubjects/AllSubjects.dart';
import 'package:poralekha_app/screens/ApproveUser/ApproveUser.dart';
import 'package:poralekha_app/screens/AllStudents/AllStudents.dart';
import 'package:poralekha_app/screens/ManageAdimin/ManageAdmin.dart';

import 'package:poralekha_app/widgets/DrawerListMenu.dart';

class MyDrawerList extends StatelessWidget {
  const MyDrawerList({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Column(
        children: [
          GestureDetector(
            child: DrawerListMenu(
              title: "Approve User".tr,
              icon: Iconsax.user,
            ),
            onTap: () {
              Get.to(ApproveUser());
            },
          ),
          // SizedBox(
          //   height: Get.height * 0.01,
          // ),
          GestureDetector(
            child: DrawerListMenu(
              title: "Manage Admin".tr,
              icon: Iconsax.teacher,
            ),
            onTap: () {
              Get.to(ManageAdminScreen());
            },
          ),
          GestureDetector(
            child: DrawerListMenu(
              title: "Add Lecture".tr,
              icon: Iconsax.video,
            ),
            onTap: () {
              Get.to(const AddLectureScreen());
            },
          ),
          GestureDetector(
            child: DrawerListMenu(
              title: "All Students".tr,
              icon: Iconsax.people,
            ),
            onTap: () {
              Get.to(const AllStudent());
            },
          ),
          GestureDetector(
            child: DrawerListMenu(
              title: "All Lectures".tr,
              icon: Iconsax.video,
            ),
            onTap: () {
              Get.to(const AllLectureScreen());
            },
          ),
          GestureDetector(
            child: DrawerListMenu(
              title: "All Subjects".tr,
              icon: Iconsax.book_14,
            ),
            onTap: () {
              Get.to(const AllSubjectsScreen());
            },
          ),
        ],
      ),
    );
  }
}

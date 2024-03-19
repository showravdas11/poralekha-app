import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/SubjectList/ChapterList/TutorVideoScreen.dart';

class TutorVideoOnline extends StatelessWidget {
  final List<dynamic> tutorials;
  const TutorVideoOnline({Key? key, required this.tutorials}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tutorials.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.1),
          child: Text(
            'No tutorials available'.tr,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    } else {
      return Column(
        children: tutorials.map((tutorial) {
          return Container(
            height: Get.height * 0.10,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Card(
              elevation: 0.5,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        //'${tutor['tutorName']} Tutorials',
                        tutorial['name'],
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(TutorVideoScreen(tutorial: tutorial));
                    },
                    child: Text("Watch Now".tr),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }
  }
}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class EditSubject extends StatefulWidget {
  final String documentId;
  final String subjectName;
  final String className;

  const EditSubject(
      {Key? key,
      required this.documentId,
      required this.subjectName,
      required this.className})
      : super(key: key);

  @override
  State<EditSubject> createState() => _EditSubjectState();
}

class _EditSubjectState extends State<EditSubject> {
  TextEditingController nameController = TextEditingController();
  String? selectClass;
  late String documentId;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.subjectName;
    selectClass = widget.className;
    documentId = widget.documentId;
  }

  Future<void> updateSubject() async {
    try {
      await FirebaseFirestore.instance
          .collection('subjects')
          .doc(documentId)
          .update({
        'name': nameController.text,
        'class': selectClass,
      });

      // Get.snackbar(
      //   'Success',
      //   'Subject details updated successfully',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Subject updated successfully',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
    } catch (error) {
      // Show error message if update fails
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Failed to update subject details. Please try again later.',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit Subject".tr,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Subject Name".tr,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            CommonTextField(
              controller: nameController,
              text: "Enter Subject Name",
              textInputType: TextInputType.text,
              obscure: false,
            ),
            const SizedBox(height: 6),
            Text(
              "Class".tr,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('classes').snapshots(),
              builder: (context, snapshot) {
                List<DropdownMenuItem<String>> classItems = [];
                if (snapshot.hasData) {
                  for (var doc in snapshot.data!.docs) {
                    String className = doc.get('name');
                    classItems.add(
                      DropdownMenuItem<String>(
                        value: className,
                        child: Text(
                          className,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }
                }
                return Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectClass,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectClass = newValue;
                      });
                    },
                    items: classItems,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Select Your Class".tr,
                      hintStyle: TextStyle(),
                      alignLabelWithHint: true,
                      iconColor: Color(0xFF7E59FD),
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            RoundedButton(
              title: "Save Changes".tr,
              onTap: updateSubject,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

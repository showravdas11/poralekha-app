import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class EditLecturesScreen extends StatefulWidget {
  final Map<String, dynamic> lectureData;
  final String lectureId;

  const EditLecturesScreen(
      {Key? key, required this.lectureData, required this.lectureId})
      : super(key: key);

  @override
  State<EditLecturesScreen> createState() => _EditLecturesScreenState();
}

class _EditLecturesScreenState extends State<EditLecturesScreen> {
  late TextEditingController topicController;
  late TextEditingController teacherNameController;
  late TextEditingController dateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController stateController;
  late TextEditingController linkController;

  @override
  void initState() {
    super.initState();
    topicController = TextEditingController(text: widget.lectureData['topic']);
    teacherNameController =
        TextEditingController(text: widget.lectureData['teacherName']);
    dateController = TextEditingController(text: widget.lectureData['date']);
    startTimeController =
        TextEditingController(text: widget.lectureData['startTime']);
    endTimeController =
        TextEditingController(text: widget.lectureData['endTime']);
    linkController = TextEditingController(text: widget.lectureData['link']);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text =
            pickedDate.toString().substring(0, 10); // Format the date as needed
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        startTimeController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        endTimeController.text = pickedTime.format(context);
      });
    }
  }

  void updateLectureData() async {
    // Ensure all required fields are filled
    if (topicController.text.trim().isEmpty ||
        teacherNameController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        startTimeController.text.trim().isEmpty ||
        endTimeController.text.trim().isEmpty ||
        linkController.text.trim().isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Enter Required Fields',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      ).show();
      return;
    }

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference lectureRef =
          firestore.collection('lecture').doc(widget.lectureId);

      await lectureRef.update({
        'topic': topicController.text,
        'teacherName': teacherNameController.text,
        'date': dateController.text,
        'startTime': startTimeController.text,
        'endTime': endTimeController.text,
        'link': linkController.text,
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Lecture Updated Successfully',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
    } catch (error) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Failed to Update Lecture',
        desc: 'An error occurred while updating the lecture: $error',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyTheme.canvousColor,
      appBar: CustomAppBar(
        title: "Edit Lecture".tr,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Topic".tr,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenSize.width * 0.04,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: screenSize.height * 0.01),
              CommonTextField(
                controller: topicController,
                text: "Topic".tr,
                textInputType: TextInputType.text,
                obscure: false,
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                "Teacher".tr,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenSize.width * 0.04,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: screenSize.height * 0.01),
              CommonTextField(
                controller: teacherNameController,
                text: "Teacher Name".tr,
                textInputType: TextInputType.text,
                obscure: false,
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                "Date".tr,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenSize.width * 0.04,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Container(
                height: screenSize.height * 0.06,
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                    )
                  ],
                ),
                child: TextFormField(
                  controller: dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    hintText: 'Select Dare',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.01),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                "Start Time".tr,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenSize.width * 0.04,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Container(
                height: screenSize.height * 0.06,
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                    )
                  ],
                ),
                child: TextFormField(
                  controller: startTimeController,
                  readOnly: true,
                  onTap: () => _selectStartTime(context),
                  decoration: InputDecoration(
                    hintText: 'Select Start Time'.tr,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.01,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                "End Time".tr,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenSize.width * 0.04,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Container(
                height: screenSize.height * 0.06,
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                    )
                  ],
                ),
                child: TextFormField(
                  controller: endTimeController,
                  readOnly: true,
                  onTap: () => _selectEndTime(context),
                  decoration: InputDecoration(
                    hintText: 'Select End Time'.tr,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.01),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                "Link".tr,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenSize.width * 0.04,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: screenSize.height * 0.01),
              CommonTextField(
                controller: linkController,
                text: "Paste Link".tr,
                textInputType: TextInputType.text,
                obscure: false,
              ),
              SizedBox(height: screenSize.height * 0.02),
              RoundedButton(
                title: "Update Lectures".tr,
                onTap: () {
                  updateLectureData();
                },
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    topicController.dispose();
    teacherNameController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }
}

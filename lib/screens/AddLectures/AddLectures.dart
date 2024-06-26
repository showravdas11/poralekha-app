import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class AddLectureScreen extends StatefulWidget {
  const AddLectureScreen({Key? key}) : super(key: key);

  @override
  State<AddLectureScreen> createState() => _AddLectureScreenState();
}

class _AddLectureScreenState extends State<AddLectureScreen> {
  TextEditingController topicController = TextEditingController();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController linkTypeController = TextEditingController();
  String? selectLinkType;
  String? selectState;
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String? selectClass;

  Future<void> addLectureData(
    String topic,
    String? Class,
    String teacherName,
    String startTime,
    String endTime,
    String link,
    String linkType,
    String date,
  ) async {
    await FirebaseFirestore.instance.collection('lecture').add({
      'topic': topic,
      'class': Class,
      'teacherName': teacherName,
      'startTime': startTime,
      'endTime': endTime,
      'link': link,
      'linkType': linkType,
      'date': date,
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedStartTime) {
      setState(() {
        selectedStartTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    if (selectedStartTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedEndTime ?? selectedStartTime!,
      );
      if (pickedTime != null) {
        final pickedDateTime =
            DateTime(1, 1, 1, pickedTime.hour, pickedTime.minute);
        final startDateTime = DateTime(
            1, 1, 1, selectedStartTime!.hour, selectedStartTime!.minute);
        if (pickedDateTime.isAfter(startDateTime)) {
          setState(() {
            selectedEndTime = pickedTime;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('End time should be after the start time.'),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the start time first.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Lecture".tr,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Topic".tr,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                  const SizedBox(
                    height: 6,
                  ),
                  CommonTextField(
                    controller: topicController,
                    text: "Enter Topic Name".tr,
                    textInputType: TextInputType.text,
                    obscure: false,
                  ),
                  const SizedBox(height: 6),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Class".tr,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('classes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DropdownMenuItem<String>> classItems = [];
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
                              )
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
                              hintStyle: const TextStyle(),
                              alignLabelWithHint: true,
                              iconColor: const Color(0xFF7E59FD),
                            ),
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  const SizedBox(height: 6),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Date".tr,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                  Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      onTap: () {
                        _selectDate(context);
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: selectedDate != null
                            ? DateFormat('dd-MM-yyyy').format(selectedDate!)
                            : "Select Class Date".tr,
                        hintStyle: const TextStyle(),
                        suffixIcon: const Icon(Icons.calendar_month),
                        alignLabelWithHint: true,
                        iconColor: const Color(0xFF7E59FD),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Teacher Name".tr,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                  CommonTextField(
                    controller: teacherNameController,
                    text: "Teacher Name".tr,
                    textInputType: TextInputType.text,
                    obscure: false,
                  ),
                  const SizedBox(height: 6),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Start Time".tr,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                  Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      onTap: () {
                        _selectStartTime(context);
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: selectedStartTime != null
                            ? selectedStartTime
                                ?.format(context)
                                .toLowerCase() // Customize as needed
                            : "Set Start Time".tr,
                        hintStyle: const TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 2,
                        ),
                        suffixIcon: const Icon(Icons.timelapse),
                        alignLabelWithHint: true,
                        iconColor: const Color(0xFF7E59FD),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "End Time".tr,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                  Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      onTap: () {
                        _selectEndTime(context);
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: selectedEndTime != null
                            ? selectedEndTime
                                ?.format(context)
                                .toString() // Customize as needed
                            : "Set End Time".tr,
                        hintStyle: const TextStyle(),
                        suffixIcon: const Icon(Icons.timelapse),
                        alignLabelWithHint: true,
                        iconColor: const Color(0xFF7E59FD),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Class Link".tr,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                  CommonTextField(
                    controller: linkController,
                    text: "Paste Link".tr,
                    textInputType: TextInputType.text,
                    obscure: false,
                  ),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Platform".tr,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                  Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    child: DropdownButtonFormField<String>(
                      value: selectLinkType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectLinkType = newValue;
                        });
                      },
                      items: [
                        'meet',
                        'zoom',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select Class Platform".tr,
                        hintStyle: const TextStyle(),
                        alignLabelWithHint: true,
                        iconColor: const Color(0xFF7E59FD),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RoundedButton(
                    title: "Add Lecture".tr,
                    onTap: () {
                      if (topicController.text.trim().isEmpty ||
                          teacherNameController.text.trim().isEmpty ||
                          selectedStartTime == null ||
                          selectedEndTime == null ||
                          linkController.text.trim().isEmpty ||
                          selectLinkType == null ||
                          selectClass == null ||
                          selectedDate == null) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Enter Required Fields',
                          btnOkColor: MyTheme.buttonColor,
                          btnOkOnPress: () {},
                        ).show();
                      } else {
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(selectedDate!);
                        String formattedStartTime =
                            MaterialLocalizations.of(context)
                                .formatTimeOfDay(selectedStartTime!);
                        String formattedEndTime =
                            MaterialLocalizations.of(context)
                                .formatTimeOfDay(selectedEndTime!);

                        addLectureData(
                          topicController.text.trim(),
                          selectClass,
                          teacherNameController.text.trim(),
                          formattedStartTime,
                          formattedEndTime,
                          linkController.text.trim(),
                          selectLinkType!,
                          formattedDate,
                        );

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Lecture Added Successfully',
                          btnOkColor: MyTheme.buttonColor,
                          btnOkOnPress: () {
                            Navigator.pop(context);
                          },
                        ).show();
                      }
                    },
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

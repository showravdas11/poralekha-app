import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
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
      'state': "pending",
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
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
      });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedStartTime)
      setState(() {
        selectedStartTime = pickedTime;
      });
  }

  Future<void> _selectEndTime(BuildContext context) async {
    if (selectedStartTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedEndTime ??
            selectedStartTime!, // Set initial time to selected end time or start time
      );
      if (pickedTime != null) {
        // Calculate the maximum selectable time (5 hours after the selected start time)
        final maxSelectableTime = TimeOfDay(
          hour: selectedStartTime!.hour + 5,
          minute: selectedStartTime!.minute,
        );
        // Convert TimeOfDay to DateTime for comparison
        final pickedDateTime =
            DateTime(1, 1, 1, pickedTime.hour, pickedTime.minute);
        final maxSelectableDateTime =
            DateTime(1, 1, 1, maxSelectableTime.hour, maxSelectableTime.minute);
        // Check if the picked time is before or equal to the maximum selectable time
        if (pickedDateTime.isBefore(maxSelectableDateTime) ||
            pickedDateTime == maxSelectableDateTime) {
          setState(() {
            selectedEndTime = pickedTime;
          });
        } else {
          // Inform the user that the selected time is not within the allowed range
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('End time should be within 5 hours of the start time.'),
            ),
          );
        }
      }
    } else {
      // Inform the user to select the start time first
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select the start time first.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Lecture",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Iconsax.arrow_left,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Topic",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                  const SizedBox(
                    height: 6,
                  ),
                  CommonTextField(
                    controller: topicController,
                    text: "Topic",
                    textInputType: TextInputType.text,
                    obscure: false,
                  ),
                  SizedBox(height: 6),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Class",
                        style: TextStyle(
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
                      value: selectClass,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectClass = newValue;
                        });
                      },
                      items: [
                        'Class HSC',
                        'Class Ten',
                        'Class Nine',
                        'Class Eight',
                        'Class Seven',
                        'Class Six',
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
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select Your Class",
                        hintStyle: TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 2,
                        ),
                        alignLabelWithHint: true,
                        iconColor: Color(0xFF7E59FD),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Date",
                        style: TextStyle(
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
                            : "Select Your date",
                        hintStyle: TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 2,
                        ),
                        suffixIcon: Icon(Icons.calendar_month),
                        alignLabelWithHint: true,
                        iconColor: Color(0xFF7E59FD),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Teacher Name",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                  CommonTextField(
                    controller: teacherNameController,
                    text: "Teacher Name",
                    textInputType: TextInputType.text,
                    obscure: false,
                  ),
                  SizedBox(height: 6),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Start Time",
                        style: TextStyle(
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
                            : "Select Start Time",
                        hintStyle: TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 2,
                        ),
                        suffixIcon: Icon(Icons.timelapse),
                        alignLabelWithHint: true,
                        iconColor: Color(0xFF7E59FD),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "End Time ",
                        style: TextStyle(
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
                            : "Select End Time",
                        hintStyle: TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 2,
                        ),
                        suffixIcon: Icon(Icons.timelapse),
                        alignLabelWithHint: true,
                        iconColor: Color(0xFF7E59FD),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Class Link",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                  CommonTextField(
                    controller: linkController,
                    text: "Link",
                    textInputType: TextInputType.text,
                    obscure: false,
                  ),
                  SizedBox(height: 10),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Platform",
                        style: TextStyle(
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
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select Your Platform",
                        hintStyle: TextStyle(
                          wordSpacing: 2,
                          letterSpacing: 2,
                        ),
                        alignLabelWithHint: true,
                        iconColor: Color(0xFF7E59FD),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  RoundedButton(
                    title: "Add Lecture",
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
                          title: 'Data Added SuccessFully',
                          btnOkColor: MyTheme.buttonColor,
                          btnOkOnPress: () {},
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

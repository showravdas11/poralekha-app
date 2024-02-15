import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/screens/AllSubjects/AllSubjects.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class AddSubjectsScreen extends StatefulWidget {
  const AddSubjectsScreen({Key? key}) : super(key: key);

  @override
  State<AddSubjectsScreen> createState() => _AddSubjectsScreenState();
}

class _AddSubjectsScreenState extends State<AddSubjectsScreen> {
  TextEditingController subjectController = TextEditingController();
  String? selectClass;

  Future<void> addLectureData(
    String name,
    String? Class,
  ) async {
    await FirebaseFirestore.instance.collection('subjects').add({
      'name': name,
      'class': Class,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Subject",
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Subject",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  )),
              SizedBox(
                height: 6,
              ),
              CommonTextField(
                controller: subjectController,
                text: "Subject",
                textInputType: TextInputType.text,
                obscure: false,
              ),
              SizedBox(
                height: 6,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Class",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  )),
              SizedBox(
                height: 6,
              ),
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
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              RoundedButton(
                  title: "Add Subject",
                  onTap: () {
                    if (subjectController.text.trim().isEmpty ||
                        selectClass == null) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Enter Required Fields',
                        btnOkColor: MyTheme.buttonColor,
                        btnOkOnPress: () {},
                      ).show();
                    } else {
                      addLectureData(
                        subjectController.text.trim(),
                        selectClass,
                      );

                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Data Added SuccessFully',
                        btnOkColor: MyTheme.buttonColor,
                        btnOkOnPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllSubjectsScreen()));
                        },
                      ).show();
                    }
                  },
                  width: double.infinity)
            ],
          ),
        ),
      ),
    );
  }
}

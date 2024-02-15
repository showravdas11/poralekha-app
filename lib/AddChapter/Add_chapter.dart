import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class AddChapterScreen extends StatefulWidget {
  const AddChapterScreen({Key? key}) : super(key: key);

  @override
  State<AddChapterScreen> createState() => _AddChapterScreenState();
}

class _AddChapterScreenState extends State<AddChapterScreen> {
  TextEditingController chapnameController = TextEditingController();
  String? _filePath;
  String? _storagePath;

  final FirebaseFirestore _firebasFirestore = FirebaseFirestore.instance;

  Future<String> uploadPdf(String fileName, File file) async {
    final reference =
        FirebaseStorage.instance.ref().child("pdfs/$fileName/.pdf");

    final uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() {});

    final downloadLink = await reference.getDownloadURL();

    return downloadLink;
  }

  //------------pick File-----------------
  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;

      File file = File(pickedFile.files[0].path!);
      final downloadLink = await uploadPdf(fileName, file); // Await here

      await _firebasFirestore.collection("pdfs").add(
        {
          "name": fileName,
          "url": downloadLink,
        },
      );
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Pdf Uploaded SuccessFully',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      ).show();
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = AppBar().preferredSize.height;
    final screenHeight = screenSize.height - appBarHeight;
    final screenWidth = screenSize.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Chapter",
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
              ),
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                height: screenHeight * 0.15,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Subject Name: Physics",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Class Ten",
                      style: TextStyle(fontSize: screenWidth * 0.05),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            CommonTextField(
              controller: chapnameController,
              text: "Add Chapter Name",
              textInputType: TextInputType.text,
              obscure: false,
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.buttonColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015,
                    horizontal: screenWidth * 0.05,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                ),
                onPressed: pickFile,
                child: Text("Upload PDF"),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            _filePath != null
                ? Column(
                    children: [
                      Text(
                        "Selected PDF: $_filePath",
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Confirm Upload"),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      _storagePath != null
                          ? Text(
                              "Storage Path: $_storagePath",
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            )
                          : Container(),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

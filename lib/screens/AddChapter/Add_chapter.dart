import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class AddChapterScreen extends StatefulWidget {
  final Map<String, dynamic> subjectData;
  final String docId;
  const AddChapterScreen(
      {Key? key, required this.subjectData, required this.docId})
      : super(key: key);

  @override
  State<AddChapterScreen> createState() => _AddChapterScreenState();
}

class _AddChapterScreenState extends State<AddChapterScreen> {
  TextEditingController chapnameController = TextEditingController();
  String? _filePath;
  late Stream<QuerySnapshot> _addChapterStream;
  bool _uploading = false;
  late File _selectedFile;

  @override
  void initState() {
    super.initState();
    _addChapterStream =
        FirebaseFirestore.instance.collection('subjects').snapshots();
  }

  final FirebaseFirestore _firebasFirestore = FirebaseFirestore.instance;

  Future<String> uploadPdf(String fileName, File file) async {
    final reference =
        FirebaseStorage.instance.ref().child("pdfs/$fileName/.pdf");

    final uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() {});

    final downloadLink = await reference.getDownloadURL();

    return downloadLink;
  }

  void pickFile() async {
    setState(() {
      _uploading = true;
    });

    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      _selectedFile = File(pickedFile.files[0].path!);
      setState(() {
        _filePath = pickedFile.files[0].path;
        _uploading = false;
      });
    } else {
      setState(() {
        _uploading = false;
      });
    }
  }

  void addChapter() async {
    if (chapnameController.text.isEmpty || _selectedFile == null) {
      // If any required field is empty, show dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Enter Required Fields',
        desc: 'Please fill all the required fields.',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      ).show();
      return;
    }

    setState(() {
      _uploading = true;
    });

    String fileName = _selectedFile.path.split('/').last;
    final downloadLink = await uploadPdf(fileName, _selectedFile);

    CollectionReference chapterCollection = FirebaseFirestore.instance
        .collection('subjects')
        .doc(widget.docId)
        .collection('chapters');

    await chapterCollection.add({
      "name": chapnameController.text,
      "pdfLink": downloadLink,
    });

    setState(() {
      _uploading = false;
    });

    chapnameController.clear();
    _filePath = null;
    _selectedFile = File('');

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Pdf Uploaded Successfully',
      btnOkColor: MyTheme.buttonColor,
      btnOkOnPress: () {},
    ).show();
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
                      "Subject Name: ${widget.subjectData['name']}",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Class: ${widget.subjectData['class']}",
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
              suffixIcon: Icon(Iconsax.add_circle),
            ),
            SizedBox(height: screenSize.height * 0.02),
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
                  pickFile();
                },
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _filePath ?? "Select Your pdf",
                  hintStyle: TextStyle(
                    wordSpacing: 2,
                    letterSpacing: 2,
                  ),
                  suffixIcon: _uploading
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(Iconsax.attach_circle),
                          onPressed: pickFile,
                        ),
                  alignLabelWithHint: true,
                  iconColor: Color(0xFF7E59FD),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: RoundedButton(
                title: "Add Chapter",
                onTap: addChapter,
                width: double.infinity,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}

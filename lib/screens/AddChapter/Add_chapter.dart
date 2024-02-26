import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/screens/AddTutorial/AddTutorials.dart';

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
  String? _gifPath;
  late Stream<QuerySnapshot> _addChapterStream;
  bool _uploading = false;
  late File _selectedFile;
  late File _gifSelectedFile;
  List<Widget> _topicWidgets = [];
  List<Widget> _tutorialsWidgets = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _linkController = TextEditingController();

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

  //upolad gif
  Future<String> uploadGif(String fileName, File file) async {
    final reference =
        FirebaseStorage.instance.ref().child("gifs/$fileName/.gif");

    final uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() {});

    final downloadLink = await reference.getDownloadURL();

    return downloadLink;
  }

  void pickGifFile() async {
    setState(() {
      _uploading = true;
    });

    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['gif'],
    );

    if (pickedFile != null) {
      _gifSelectedFile = File(pickedFile.files[0].path!);
      setState(() {
        _gifPath =
            pickedFile.files[0].path; // Correcting the variable assignment
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

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Pdf Uploaded Successfully',
      btnOkColor: MyTheme.buttonColor,
      btnOkOnPress: () {},
    ).show();
  }

  Widget _buildTopicHolder(
      TextEditingController controller, double screenHeight) {
    return Column(
      children: [
        CommonTextField(
          controller: controller,
          text: "Enter Topic Name",
          textInputType: TextInputType.text,
          obscure: false,
          suffixIcon: const Icon(Iconsax.add_circle),
        ),
        SizedBox(height: screenHeight * 0.02),
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
              pickGifFile();
            },
            readOnly: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: _gifPath ?? "Select topic Animation",
              hintStyle: const TextStyle(
                wordSpacing: 2,
                letterSpacing: 2,
              ),
              suffixIcon: _uploading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      icon: const Icon(Iconsax.gallery_add),
                      onPressed: pickGifFile,
                    ),
              alignLabelWithHint: true,
              iconColor: const Color(0xFF7E59FD),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = AppBar().preferredSize.height;
    final screenHeight = screenSize.height - appBarHeight;
    final screenWidth = screenSize.width;
    TextEditingController topicController = TextEditingController();
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
                  // image: const DecorationImage(
                  //   image: AssetImage("assets/images/aaa.png"),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Subject: ${widget.subjectData['name']}",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        // color: Colors
                        //     .white, // Adjust text color to make it visible on the background image
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "${widget.subjectData['class']}",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                      ), // Adjust text color
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            CommonTextField(
              controller: chapnameController,
              text: "Enter Chapter Name",
              textInputType: TextInputType.text,
              obscure: false,
              suffixIcon: const Icon(Iconsax.add_circle),
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
                  hintText: _filePath ?? "Select Chapter PDF",
                  hintStyle: const TextStyle(
                    wordSpacing: 2,
                    letterSpacing: 2,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Iconsax.book_14),
                    onPressed: pickFile,
                  ),
                  alignLabelWithHint: true,
                  iconColor: const Color(0xFF7E59FD),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Topics",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      TextEditingController newController =
                          TextEditingController();
                      _topicWidgets
                          .add(_buildTopicHolder(newController, screenHeight));
                    });
                  },
                  child: const Text("Add More"),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Column(
              children: [
                CommonTextField(
                  controller: topicController,
                  text: "Enter Topic Name",
                  textInputType: TextInputType.text,
                  obscure: false,
                  suffixIcon: const Icon(Iconsax.add_circle),
                ),
                SizedBox(height: screenHeight * 0.02),
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
                      pickGifFile();
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _gifPath ?? "Select topic Animation",
                      hintStyle: const TextStyle(
                        wordSpacing: 2,
                        letterSpacing: 2,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Iconsax.gallery_add),
                        onPressed: pickGifFile,
                      ),
                      alignLabelWithHint: true,
                      iconColor: const Color(0xFF7E59FD),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Column(
              children: _topicWidgets.map((widget) {
                return Column(
                  children: [
                    widget,
                    SizedBox(height: screenHeight * 0.02),
                  ],
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Tutorials",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tutorialsWidgets.add(_buildCummonTextField(
                          _nameController,
                          _linkController,
                          screenHeight)); // Add the text field widget to the list
                      _nameController =
                          TextEditingController(); // Reset the controller for the next text field
                      _linkController =
                          TextEditingController(); // Reset the controller for the next text field
                    });
                  },
                  child: const Text("Add More"),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            CommonTextField(
              controller: _nameController,
              text: "Enter Tutorials Name",
              textInputType: TextInputType.text,
              obscure: false,
              suffixIcon: const Icon(Iconsax.text),
            ),
            SizedBox(height: screenHeight * 0.02),
            CommonTextField(
              controller: _linkController,
              text: "Paste Tutorials Link",
              textInputType: TextInputType.text,
              obscure: false,
              suffixIcon: const Icon(Iconsax.link),
            ),
            SizedBox(height: screenHeight * 0.02),
            Column(
              children: _tutorialsWidgets.map((widget) {
                return Column(
                  children: [
                    widget,
                    SizedBox(height: screenHeight * 0.02),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: RoundedButton(
                title: "Add",
                onTap: addChapter,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCummonTextField(TextEditingController nameController,
    TextEditingController linkController, double screenHeight) {
  return Column(
    children: [
      CommonTextField(
        controller: nameController,
        text: "Enter Tutorials Name",
        textInputType: TextInputType.text,
        obscure: false,
        suffixIcon: const Icon(Iconsax.text),
      ),
      SizedBox(height: screenHeight * 0.02),
      CommonTextField(
        controller: linkController,
        text: "Paste Tutorials Link",
        textInputType: TextInputType.text,
        obscure: false,
        suffixIcon: const Icon(Iconsax.link),
      ),
    ],
  );
}

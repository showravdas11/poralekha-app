import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class AddChapterScreen extends StatefulWidget {
  final String documentId;
  final String className;
  final String subjectName;

  const AddChapterScreen(
      {Key? key, required this.documentId, required this.className, required this.subjectName})
      : super(key: key);

  @override
  State<AddChapterScreen> createState() => _AddChapterScreenState();
}

class _AddChapterScreenState extends State<AddChapterScreen> {
  TextEditingController chapterNameController = TextEditingController();
  File? _selectedPdf;
  String _pdfPath = "";

  final List<Widget> _topicWidgets = [];
  final List<TextEditingController> _topicNameControllers = [];
  final List<String> _gifPaths = [];
  final List<File?> _gifs = [];
  BuildContext? dialogContext;

  final List<Widget> _tutorialWidgets = [];
  final List<TextEditingController> _tutorialNameControllers = [];
  final List<TextEditingController> _tutorialLinkControllers = [];

  @override
  void initState() {
    super.initState();
    _gifs.add(null);
    _gifPaths.add("");
    _topicNameControllers.add(TextEditingController());
    _topicWidgets.add(_buildTopicHolder(_topicNameControllers.last, 0));

    _tutorialNameControllers.add(TextEditingController());
    _tutorialLinkControllers.add(TextEditingController());
    _tutorialWidgets.add(_tutorialHolder(
        _tutorialNameControllers.last, _tutorialLinkControllers.last));
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void pickFile(String type, { gifIndex = -1 }) async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [type],
    );

    if (pickedFile != null) {
      if (type == 'pdf') {
        _selectedPdf = File(pickedFile.files[0].path!);
      } else {
        _gifs[gifIndex] = File(pickedFile.files[0].path!);
      }

      setState(() {
        if (type == 'pdf') {
          _pdfPath = pickedFile.files[0].path?.split('/').last ?? "";
        } else {
          setState(() {
            _gifPaths[gifIndex] = pickedFile.files[0].path?.split('/').last ?? "";
          });
        }
      });
    }
  }

  Future<String> uploadFile(File? file, String type) async {
    if (file == null) {
      return "";
    }
    String fileName = file.path.split('/').last;
    final reference = FirebaseStorage.instance.ref().child("${type}s/$fileName");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await reference.getDownloadURL();
    print("${type} download link: $downloadLink");
    return downloadLink;
  }

  void addChapter() async {
    bool isTopicOk = true;
    for(int i = 0; i < _topicWidgets.length; i++) {
      if (_topicNameControllers[i].text == "" || _gifs[i] == null) {
        isTopicOk = false;
      }
    }
    bool isTutorialOk = true;
    for(int i = 0; i < _tutorialWidgets.length; i++) {
      if (_tutorialNameControllers[i].text == "" || _tutorialLinkControllers[i].text == "") {
        isTutorialOk = false;
      }
    }
    if (chapterNameController.text.isEmpty || _selectedPdf == null || !isTopicOk || !isTutorialOk) {
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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          content: SpinKitCircle(
              color: Colors.white, size: 50.0),
        );
      },
    );

    String pdfLink = await uploadFile(_selectedPdf, 'pdf');
    List<String> gifLinks = [];
    for (File? gif in _gifs) {
      String gifLink = await uploadFile(gif, 'gif');
      gifLinks.add(gifLink);
    }

    if (pdfLink == "" && _gifs.length != gifLinks.length) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Something went wrong uploading pdf',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      ).show();
    } else {
      List<Map<String, String>> topicData = [];
      for (int i = 0; i < _topicWidgets.length; i++) {
        topicData.add({
          'animationUrl': gifLinks[i],
          'topicName': _topicNameControllers[i].text
        });
      }

      List<Map<String, String>> tutorialData = [];
      for (int i = 0; i < _tutorialWidgets.length; i++) {
        tutorialData.add({
          'name': _tutorialNameControllers[i].text,
          'videoLink': _tutorialLinkControllers[i].text
        });
      }

      CollectionReference chapterCollection = FirebaseFirestore.instance
          .collection('subjects')
          .doc(widget.documentId)
          .collection('chapters');
      try {
        await chapterCollection.add({
          "name": chapterNameController.text,
          "pdfLink": pdfLink,
          "topics": topicData,
          "tutorials": tutorialData
        });

        Navigator.pop(dialogContext!);

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Chapter added successfully',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        )..show();
      } catch(e) {
        Navigator.pop(dialogContext!);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Something went wrong',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
                padding: EdgeInsets.all(screenWidth * 0.05),
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
                      "${"Subject"}: ${widget.subjectName}",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        // color: Colors
                        //     .white, // Adjust text color to make it visible on the background image
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "${"Class"}: ${widget.className}",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            CommonTextField(
              controller: chapterNameController,
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
                  pickFile('pdf');
                },
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _pdfPath != "" ? _pdfPath : "Select Chapter PDF",
                  hintStyle: const TextStyle(
                    wordSpacing: 2,
                    letterSpacing: 2,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Iconsax.book_14),
                    onPressed: () {
                      pickFile('pdf');
                    },
                  ),
                  alignLabelWithHint: true,
                  iconColor: const Color(0xFF7E59FD),
                ),
              ),
            ),
            const SizedBox(height: 15),
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
                      int len = _topicWidgets.length;
                      _topicNameControllers.add(TextEditingController());
                      _gifs.add(null);
                      _gifPaths.add("");
                      _topicWidgets.add(_buildTopicHolder(_topicNameControllers.last, len));
                    });
                  },
                  child: const Text("Add More"),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              children: _topicWidgets.map((widget) {
                return Column(
                  children: [
                    widget,
                    const SizedBox(height: 15),
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
                      _tutorialNameControllers.add(TextEditingController());
                      _tutorialLinkControllers.add(TextEditingController());
                      _tutorialWidgets.add(_tutorialHolder(
                          _tutorialNameControllers.last,
                          _tutorialLinkControllers.last));
                    });
                  },
                  child: const Text("Add More"),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              children: _tutorialWidgets.map((widget) {
                return Column(
                  children: [
                    widget,
                    const SizedBox(height: 15),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
            Center(
              child: RoundedButton(
                title: "Add Chapter",
                onTap: () {
                  addChapter();
                },
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicHolder(TextEditingController topicNameController, int index) {
    return Column(
      children: [
        CommonTextField(
          controller: topicNameController,
          text: "Enter Topic Name",
          textInputType: TextInputType.text,
          obscure: false,
          suffixIcon: const Icon(Iconsax.add_circle),
        ),
        const SizedBox(height: 15),
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
              pickFile('gif', gifIndex: index);
            },
            readOnly: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: _gifPaths[index] != "" ? _gifPaths[index] : "Select topic Animation",
              hintStyle: const TextStyle(
                wordSpacing: 2,
                letterSpacing: 2,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Iconsax.gallery_add),
                onPressed: (){
                  pickFile('gif', gifIndex: index);
                },
              ),
              alignLabelWithHint: true,
              iconColor: const Color(0xFF7E59FD),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tutorialHolder(TextEditingController nameController,
      TextEditingController linkController) {
    return Column(
      children: [
        CommonTextField(
          controller: nameController,
          text: "Enter Tutorials Name",
          textInputType: TextInputType.text,
          obscure: false,
          suffixIcon: const Icon(Iconsax.text),
        ),
        const SizedBox(height: 15),
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
}

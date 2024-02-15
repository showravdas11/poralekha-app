import 'dart:io';
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

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> _uploadPDF() async {
    if (_filePath == null) return;

    File file = File(_filePath!);
    String fileName = file.path.split('/').last;

    try {
      Reference reference =
          FirebaseStorage.instance.ref().child('pdfs/$fileName');
      await reference.putFile(file);

      // Get download URL
      String downloadURL = await reference.getDownloadURL();

      // Get storage path location
      String storagePath = reference.fullPath;

      // Now you can save this downloadURL and storagePath to Firestore along with any other information you need.
      // For example, you can save them under a 'chapters' collection.

      // Here's an example of how to do it using FirebaseFirestore:
      // FirebaseFirestore.instance.collection('chapters').add({
      //   'chapterName': chapnameController.text,
      //   'pdfURL': downloadURL,
      //   'storagePath': storagePath,
      // });

      // Clear the file path after upload
      setState(() {
        _filePath = null;
        _storagePath = storagePath;
      });

      // Show a message indicating successful upload
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('PDF uploaded successfully!'),
      ));
    } catch (e) {
      print('Error uploading PDF: $e');
      // Show an error message if upload fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error uploading PDF. Please try again later.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Chapter",
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Subject Name: Physics",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Class Ten",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            CommonTextField(
              controller: chapnameController,
              text: "Add Chapter Name",
              textInputType: TextInputType.text,
              obscure: false,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.buttonColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: _pickPDF,
                child: Text("Upload PDF"),
              ),
            ),
            SizedBox(height: 20),
            _filePath != null
                ? Column(
                    children: [
                      Text(
                        "Selected PDF: $_filePath",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: _uploadPDF,
                          child: Text("Confirm Upload"),
                        ),
                      ),
                      SizedBox(height: 10),
                      _storagePath != null
                          ? Text(
                              "Storage Path: $_storagePath",
                              style: TextStyle(fontSize: 16),
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

import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const UpdateProfileScreen({Key? key, required this.userData})
      : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? _selectedImage;
  BuildContext? dialogContext;
  String? selectGender;

  // late Future<QuerySnapshot> _usersStream;
  final auth = FirebaseAuth.instance;

  late Timer _timer;
  List<String> quotes = [
    """"The expert in anything was once a beginner." - Helen Hayes """,
    """ "The only way to do great work is to love what you do." - Steve Jobs """,
    """ "The secret of getting ahead is getting started." - Mark Twain """,
    """ "Success is the sum of small efforts, repeated day in and day out." - Robert Collier """,
    // Add more quotes here as needed
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the timer to change the quote every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        // Increment the currentIndex to display the next quote
        currentIndex = (currentIndex + 1) % quotes.length;
      });
    });

    nameController.text = widget.userData['name'] ?? 'N/A';
    addressController.text = widget.userData['address'] ?? 'N/A';
    ageController.text = widget.userData['age']?.toString() ?? 'N/A';
    setState(() {
      selectGender = widget.userData['gender'] ?? 'N/A';
    });
  }

  @override
  void dispose() {
    // Cancel the timer to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }

  //-----------------update user profile function--------------------//
  Future<void> _updateUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Upload image to Firebase Storage
        String imagePath = 'profile_images/${user.uid}_profile.jpg';
        Reference storageReference =
            FirebaseStorage.instance.ref().child(imagePath);
        String imageUrl = widget.userData['img'];
        if (_selectedImage != null) {
          await storageReference.putFile(_selectedImage!);
          imageUrl = await storageReference.getDownloadURL();
        }

        // Update user data in Firebase Realtime Database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': nameController.text,
          'gender': selectGender,
          'address': addressController.text,
          'age': ageController.text,
          'img': imageUrl,
        });

        Navigator.pop(dialogContext!);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Data Updated Successfully',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user data: $error')),
      );
    }
  }

  //------------------image select form gallery----------------------//

  Future<void> _picImageFormGallery() async {
    final picker = ImagePicker();
    final pickedImage = await showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(
                        Iconsax.gallery_add,
                        size: 30,
                        color: Color.fromARGB(255, 142, 36, 171),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  onTap: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    Navigator.of(context).pop(File(pickedFile!.path));
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(
                        Icons.camera,
                        size: 30,
                        color: Color.fromARGB(255, 48, 96, 78),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  onTap: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    Navigator.of(context).pop(File(pickedFile!.path));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.canvousColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF7E59FD),
                    Color(0xFF5B37B7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 10,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Edit Profile".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: widget.userData["img"] != ""
                                        ? Image.network(
                                            widget.userData["img"]!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            "assets/images/person-placeholder.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 0, right: 0),
                            child: GestureDetector(
                              onTap: _picImageFormGallery,
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 25,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Name".tr,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CommonTextField(
                        controller: nameController,
                        text: "Name",
                        textInputType: TextInputType.text,
                        obscure: false,
                        suffixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFF7E59FD),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Gender".tr,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2)
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectGender,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectGender = newValue;
                            });
                          },
                          items: ['Male', 'Female', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    color: Color.fromARGB(
                                      255,
                                      0,
                                      0,
                                      0,
                                    ),
                                    fontWeight: FontWeight.normal),
                              ),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              alignLabelWithHint: true,
                              iconColor: Color(0xFF7E59FD)),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Address".tr,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CommonTextField(
                        controller: addressController,
                        text: "Address",
                        textInputType: TextInputType.text,
                        obscure: false,
                        suffixIcon: const Icon(Icons.location_on,
                            color: Color(0xFF7E59FD)),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Age".tr,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CommonTextField(
                        controller: ageController,
                        text: "Age",
                        textInputType: TextInputType.number,
                        obscure: false,
                        suffixIcon: const Icon(Icons.calendar_today,
                            color: Color(0xFF7E59FD)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RoundedButton(
                    title: "Update".tr,
                    onTap: () {
                      if (nameController.text.trim().isEmpty ||
                          addressController.text.trim().isEmpty ||
                          ageController.text.trim().isEmpty ||
                          selectGender == null) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Enter Required Fields',
                          btnOkColor: MyTheme.buttonColor,
                          btnOkOnPress: () {},
                        ).show();
                      } else {
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

                        _updateUserData();
                      }
                    },
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

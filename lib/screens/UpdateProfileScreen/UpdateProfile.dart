import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  // TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? _selectedImage;
  BuildContext? dialogContext;
  String? selectGender;

  late Stream<QuerySnapshot> _usersStream;
  final auth = FirebaseAuth.instance;

//-----------------data fetching---------------------//
  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .snapshots();
  }

//-----------------update user profile function--------------------//
  Future<void> _updateUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              'name': nameController.text,
              'gender': selectGender,
              'address': addressController.text,
              'age': ageController.text,
            });
          });
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
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
                  const Positioned(
                    top: 50,
                    left: 20,
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment
                            .bottomRight, // Aligns the camera icon to the bottom right
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
                                    child: Image.asset(
                                      "assets/images/person-placeholder.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ), // Empty container, you can handle this case as per your requirement
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 0, right: 0), // Adjust margin as needed
                            child: GestureDetector(
                              onTap: _picImageFormGallery,
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 40, // Adjust icon size as needed
                                color: Color(0xFF7E59FD),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something Went Wrong"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("No Data Found"),
                        );
                      }

                      var userData = snapshot.data!.docs.first.data()
                          as Map<String, dynamic>;

                      nameController.text = userData['name'] ?? 'N/A';
                      selectGender = userData['gender'] ?? "N/A";
                      addressController.text = userData['address'] ?? 'N/A';
                      ageController.text = userData['age'].toString() ?? 'N/A';

                      return Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Name",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              )),
                          CommonTextField(
                            controller: nameController,
                            text: "Name",
                            textInputType: TextInputType.text,
                            obscure: false,
                            suffixIcon: const Icon(Icons.person),
                            // label: "Address",
                          ),
                          const SizedBox(height: 15),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Gender",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              )),
                          Container(
                            height: 55,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 2)
                                ]),
                            child: DropdownButtonFormField<String>(
                              value: selectGender,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectGender = newValue;
                                });
                              },
                              items: [
                                'Male',
                                'Female',
                                'Other'
                              ].map<DropdownMenuItem<String>>((String value) {
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
                                  // labelText: 'Gender'
                                  alignLabelWithHint: true),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Address",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              )),
                          CommonTextField(
                            controller: addressController,
                            text: "Address",
                            textInputType: TextInputType.text,
                            obscure: false,
                            suffixIcon: const Icon(Icons.location_on),
                            // label: "Address",
                          ),
                          const SizedBox(height: 15),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Age",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              )),
                          CommonTextField(
                            controller: ageController,
                            text: "Age",
                            textInputType: TextInputType.text,
                            obscure: false,
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  RoundedButton(
                    title: "Update",
                    onTap: () {
                      print(" Gennnnn ${selectGender}");
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

                      // _updateUserData();
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

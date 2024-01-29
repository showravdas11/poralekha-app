import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? _selectedImage;

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
        FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              'name': nameController.text,
              'email': emailController.text,
              'address': addressController.text,
              'age': ageController.text,
            });
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
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
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                    ),
                  ),
                  Positioned(
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
                      child: GestureDetector(
                        onTap: _picImageFormGallery,
                        child: Container(
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
                              : Icon(
                                  Icons.camera_alt_outlined,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Something Went Wrong"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text("No Data Found"),
                        );
                      }

                      var userData = snapshot.data!.docs.first.data()
                          as Map<String, dynamic>;

                      nameController.text = userData['name'] ?? 'N/A';
                      emailController.text = userData['email'] ?? 'N/A';
                      addressController.text = userData['address'] ?? 'N/A';
                      ageController.text = userData['age'].toString() ?? 'N/A';

                      return Column(
                        children: [
                          CommonTextField(
                            controller: nameController,
                            text: "Name",
                            textInputType: TextInputType.text,
                            obscure: false,
                            suffixIcon: Icon(Icons.person),
                            // label: "Address",
                          ),
                          SizedBox(height: 15),
                          CommonTextField(
                            controller: emailController,
                            text: "E-mail",
                            textInputType: TextInputType.text,
                            obscure: false,
                            suffixIcon: Icon(Icons.email),
                            // label: "Address",
                          ),
                          SizedBox(height: 15),
                          CommonTextField(
                            controller: addressController,
                            text: "Address",
                            textInputType: TextInputType.text,
                            obscure: false,
                            suffixIcon: Icon(Icons.location_on),
                            // label: "Address",
                          ),
                          SizedBox(height: 15),
                          CommonTextField(
                            controller: ageController,
                            text: "Age",
                            textInputType: TextInputType.text,
                            obscure: false,
                            suffixIcon: Icon(Icons.calendar_today),
                            label: Text("Address"),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  RoundedButton(
                    title: "Update",
                    onTap: () {
                      _updateUserData();
                    },
                    width: 200,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  // String? profileImageUrl = widget.userData['profileImageUrl'];

  late Stream<QuerySnapshot> _usersStream;
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
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        // Increment the currentIndex to display the next quote
        currentIndex = (currentIndex + 1) % quotes.length;
      });
    });

    // Fetch user data
    User? user = FirebaseAuth.instance.currentUser;
    _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .snapshots();
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
        await storageReference.putFile(_selectedImage!);

        // Get the download URL of the uploaded image
        String imageUrl = await storageReference.getDownloadURL();

        // Update user data in Firebase Realtime Database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': nameController.text,
          'gender': selectGender,
          'address': addressController.text,
          'age': ageController.text,
          'profileImageUrl': imageUrl, // Store image URL in the database
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
          title: Text('Select Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Row(
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
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Row(
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
                                    child: widget.userData["profileImageUrl"] !=
                                            null
                                        ? Image.network(
                                            widget.userData["profileImageUrl"]!,
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
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Name",
                              style: TextStyle(
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
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Gender",
                              style: TextStyle(
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
                                  alignLabelWithHint: true,
                                  iconColor: Color(0xFF7E59FD)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Address",
                              style: TextStyle(
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
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Age",
                              style: TextStyle(
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
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  RoundedButton(
                    title: "Update",
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

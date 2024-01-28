// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:poralekha_app/common/CommonTextField.dart';
// import 'package:poralekha_app/common/RoundedButton.dart';
// import 'package:poralekha_app/theme/myTheme.dart';

// class OneDesign extends StatefulWidget {
//   const OneDesign({Key? key}) : super(key: key);

//   @override
//   State<OneDesign> createState() => _OneDesignState();
// }

// class _OneDesignState extends State<OneDesign> {
//   TextEditingController nameController = TextEditingController();
//   File? _selectedImage;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyTheme.canvousColor,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               height: 220,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF7E59FD),
//                     Color(0xFF5B37B7),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Positioned.fill(
//                     child: Container(
//                       alignment: Alignment.center,
//                     ),
//                   ),
//                   Positioned(
//                     top: 50,
//                     left: 20,
//                     child: Text(
//                       "Profile",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: GestureDetector(
//                         onTap: _picImageFormGallery,
//                         child: Container(
//                           width: 120,
//                           height: 120,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(60),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.3),
//                                 blurRadius: 10,
//                                 spreadRadius: 3,
//                               ),
//                             ],
//                           ),
//                           child: _selectedImage != null
//                               ? ClipRRect(
//                                   borderRadius: BorderRadius.circular(60),
//                                   child: Image.file(
//                                     _selectedImage!,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 )
//                               : Icon(
//                                   Icons.camera_alt_outlined,
//                                   size: 50,
//                                   color: Colors.grey,
//                                 ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   CommonTextField(
//                     controller: nameController,
//                     text: "Name",
//                     textInputType: TextInputType.text,
//                     obscure: false,
//                     suffixIcon: Icon(Icons.person),
//                   ),
//                   SizedBox(height: 15),
//                   CommonTextField(
//                     controller: nameController,
//                     text: "E-mail",
//                     textInputType: TextInputType.text,
//                     obscure: false,
//                     suffixIcon: Icon(Icons.email),
//                   ),
//                   SizedBox(height: 15),
//                   CommonTextField(
//                     controller: nameController,
//                     text: "Address",
//                     textInputType: TextInputType.text,
//                     obscure: false,
//                     suffixIcon: Icon(Icons.location_on),
//                   ),
//                   SizedBox(height: 15),
//                   CommonTextField(
//                     controller: nameController,
//                     text: "Age",
//                     textInputType: TextInputType.text,
//                     obscure: false,
//                     suffixIcon: Icon(Icons.calendar_today),
//                   ),
//                   SizedBox(height: 20),
//                   RoundedButton(
//                     title: "Update",
//                     onTap: () {},
//                     width: 200,
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _picImageFormGallery() async {
//     final pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//       });
//     }
//   }
// }

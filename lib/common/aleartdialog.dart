// import 'package:flutter/material.dart';

// class UiHelper {
//   static customAlertBox(BuildContext context, String text) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(text),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context)
//                     .pop(); // Close the dialog when Ok is pressed
//               },
//               child: Text(
//                 "Ok",
//                 style: TextStyle(
//                   color: Colors.blue, // Change the text color
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//           shape: RoundedRectangleBorder(
//             borderRadius:
//                 BorderRadius.circular(15.0), // Adjust the border radius
//           ),
//           backgroundColor: Colors.white, // Change the background color
//         );
//       },
//     );
//   }
// }

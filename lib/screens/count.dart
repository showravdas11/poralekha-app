// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

// // OUR PACKAGE
// import 'package:countup/countup.dart';

// class CounterApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("User Count"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             StreamBuilder(
//               stream:
//                   FirebaseFirestore.instance.collection('users').snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator(); // Display a loader while waiting for data
//                 } else {
//                   if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   } else {
//                     final userCount =
//                         snapshot.data!.size.toDouble(); // Cast to double
//                     return Countup(
//                       begin: 0,
//                       end: userCount,
//                       duration: Duration(seconds: 1),
//                       separator: ',',
//                       style: TextStyle(
//                         fontSize: 36,
//                       ),
//                     );
//                   }
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

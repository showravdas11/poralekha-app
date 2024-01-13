// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:poralekha_app/bottomNavBar/bottom_nav_bar.dart';
// import 'package:poralekha_app/googlesignin/user_controller.dart';
// import 'package:poralekha_app/theme/myTheme.dart';

// class SocialButton extends StatefulWidget {
//   const SocialButton({super.key, required this.text});

//   final String text;

//   @override
//   State<SocialButton> createState() => _SocialButtonState();
// }

// class _SocialButtonState extends State<SocialButton> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           alignment: Alignment.center,
//           child: Text(
//             widget.text,
//             style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 18,
//                 color: Colors.black.withOpacity(0.5)),
//           ),
//         ),
//         SizedBox(
//           height: 40,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 55,
//               width: 70,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(5),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black.withOpacity(0.1), blurRadius: 10)
//                   ]),
//               alignment: Alignment.center,
//               child: IconButton(
//                 onPressed: () {
//                   // print("Heloooooooooooooooooooooooooooooooooooooooooooo");
//                   // try {
//                   //   await UserController
//                   //       .signOut(); // Clear previous user session
//                   //   final user = await UserController.loginWithGoogle();
//                   //   print(" My user ${user}");
//                   //   if (user != null && mounted) {
//                   //     Navigator.push(
//                   //       context,
//                   //       MaterialPageRoute(
//                   //         builder: (context) => const BottomNavBar(),
//                   //       ),
//                   //     );
//                   //   }
//                   // } catch (error) {
//                   //   print("Google Sign-In Error: $error");
//                   //   AwesomeDialog(
//                   //     context: context,
//                   //     dialogType: DialogType.info,
//                   //     animType: AnimType.rightSlide,
//                   //     title: error.toString(),
//                   //     btnOkColor: MyTheme.buttonColor,
//                   //     btnOkOnPress: () {},
//                   //   )..show();
//                   // }
//                 },
//                 icon: Image(
//                   width: 40.0,
//                   height: 40.0,
//                   image: AssetImage("assets/images/google-icon.png"),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 16,
//             ),
//             Container(
//               height: 55,
//               width: 70,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(5),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                     )
//                   ]),
//               alignment: Alignment.center,
//               child: IconButton(
//                 onPressed: () {},
//                 icon: Image(
//                   width: 40.0,
//                   height: 40.0,
//                   image: AssetImage("assets/images/facebook-icon.png"),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

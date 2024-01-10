import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // fontFamily: GoogleFonts.lato().fontFamily,
        canvasColor: WhiteColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            // backgroundColor: darkBluishColor,
            ),
        // buttonTheme: ButtonThemeData(buttonColor: darkBluishColor),
        useMaterial3: true,
        // appBarTheme: AppBarTheme(
        //   color: Colors.white,
        //   elevation: 0.0,
        //   iconTheme: IconThemeData(color: Colors.black),
        //   centerTitle: true
        // )
      );

  // colors

  static Color WhiteColor = Color.fromARGB(255, 255, 255, 255);
  static Color buttonColor = Color(0xFF375FBE);
  static Color lightBluishColor = const Color.fromRGBO(99, 102, 241, 1);
}

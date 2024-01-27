import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // fontFamily: GoogleFonts.lato().fontFamily,
        canvasColor: canvousColor,
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

  static Color canvousColor = Color(0xFFF0F8FF);
  static Color buttonColor = Color(0xFF7E59FD);
  static Color lightBluishColor = const Color.fromRGBO(99, 102, 241, 1);
}

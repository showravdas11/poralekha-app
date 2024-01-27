import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField(
      {super.key,
      required this.controller,
      required this.text,
      required this.textInputType,
      required this.obscure,
      this.suffixIcon});

  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;
  final suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2)
          ]),
      child: TextFormField(
        obscureText: obscure,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: text,
          hintStyle: TextStyle(wordSpacing: 2, letterSpacing: 2),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

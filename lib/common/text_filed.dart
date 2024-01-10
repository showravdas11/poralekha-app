import 'package:flutter/material.dart';

class TextFormFiledCommon extends StatelessWidget {
  const TextFormFiledCommon(
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
      height: 50,
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
      decoration: BoxDecoration(
          color: Color(0xFFEDEDED),
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

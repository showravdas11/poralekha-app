import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    Key? key,
    required this.controller,
    required this.text,
    required this.textInputType,
    required this.obscure,
    this.labelText,
    this.suffixIcon,
    this.decoration,
  }) : super(key: key);

  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;
  final Widget? suffixIcon;
  final String? labelText;
  final InputDecoration? decoration;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.06, // Adjust height based on screen height
      padding: EdgeInsets.symmetric(
          horizontal:
              screenWidth * 0.03), // Adjust padding based on screen width
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2),
        ],
      ),
      child: Center(
        child: TextFormField(
          obscureText: widget.obscure,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          style: TextStyle(
              fontSize:
                  screenWidth * 0.04), // Adjust font size based on screen width
          decoration: widget.decoration ??
              InputDecoration(
                suffixIcon: widget.suffixIcon,
                hintText: widget.text,
                labelText: widget.labelText,
                hintStyle: TextStyle(wordSpacing: 2, letterSpacing: 2),
                border: InputBorder.none,
              ),
        ),
      ),
    );
  }
}

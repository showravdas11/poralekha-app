import 'package:flutter/material.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final double width;
  const RoundedButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: width,
        decoration: BoxDecoration(
          color: MyTheme.buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
        ),
      ),
    );
  }
}

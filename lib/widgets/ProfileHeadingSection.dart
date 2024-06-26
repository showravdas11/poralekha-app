import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeadingSection extends StatelessWidget {
  HeadingSection({
    Key? key,
    this.onPressed,
    this.textColor,
    this.icon,
    this.buttonTitle = "Edit",
    required this.title,
    this.showActionButton = true,
  }) : super(key: key);

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          TextButton.icon(
            onPressed: onPressed,
            icon: Icon(
              icon ?? Icons.edit,
              color: Color(0xFF7E59FD),
              size: 15,
            ), // Use edit icon or provided icon
            label: Text(
              buttonTitle.tr,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7E59FD)),
            ),
          )
      ],
    );
  }
}

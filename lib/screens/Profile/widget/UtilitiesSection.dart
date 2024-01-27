import 'package:flutter/material.dart';

class UtilitiesSection extends StatelessWidget {
  const UtilitiesSection({
    Key? key,
    required this.title,
    required this.subTitle,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  final IconData? icon;
  final String title, subTitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Card(
          elevation: 0.5,
          color: Color.fromARGB(255, 255, 255, 255),
          child: ListTile(
            title: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            leading: icon != null
                ? Icon(
                    icon,
                    color: Color(0xFF7E59FD),
                  )
                : null,
            trailing: TextButton(
              onPressed: onPressed,
              child: Text(
                subTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DrawerListMenu extends StatelessWidget {
  const DrawerListMenu({
    Key? key,
    required this.title,
    this.icon,
  }) : super(key: key);

  final IconData? icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Card(
          elevation: 0.5,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: ListTile(
            title: Text(title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600)),
            leading: icon != null
                ? Icon(
                    icon,
                    color: const Color(0xFF7E59FD),
                  )
                : null,

            // Use the icon if provided
          ),
        ),
      ),
    );
  }
}

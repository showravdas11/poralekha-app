import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyDrawerList extends StatelessWidget {
  const MyDrawerList({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Iconsax.element_3),
            title: const Text("Dashboard"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Iconsax.paintbucket),
            title: const Text("Theme"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Iconsax.star_1),
            title: const Text("Rate our App"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Iconsax.call_calling),
            title: const Text("Contact Us"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
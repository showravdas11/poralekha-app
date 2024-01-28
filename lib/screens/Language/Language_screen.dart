import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<String> options = ['English', 'বাংলা'];
  String currentOption = 'English';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Language",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.close),
                )
              ],
            ),
          ),
          Divider(
            thickness: 0.5,
            color: Colors.grey.shade300,
          ),
          ListTile(
            title: const Text("English"),
            onTap: () {
              Get.updateLocale(Locale('en', 'US'));
            },
          ),
          Divider(
            thickness: 0.5,
            color: Colors.grey.shade300,
          ),
          ListTile(
            title: const Text("বাংলা"),
            onTap: () {
              Get.updateLocale(Locale('bd', 'BAN'));
            },
          ),
        ],
      ),
    );
  }
}

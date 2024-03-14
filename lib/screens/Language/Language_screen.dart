import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late SharedPreferences _preferences;
  List<String> options = ['English', 'বাংলা'];
  String currentOption = 'English';

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  void _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    String savedLanguage = _preferences.getString('language') ?? 'en_US';
    setState(() {
      currentOption = savedLanguage == 'en_US' ? 'English' : 'বাংলা';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.27,
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
              _saveLanguage('en_US');
            },
          ),
          Divider(
            thickness: 0.5,
            color: Colors.grey.shade300,
          ),
          ListTile(
            title: const Text("বাংলা"),
            onTap: () {
              _saveLanguage('bd_BAN');
            },
          ),
        ],
      ),
    );
  }

  void _saveLanguage(String languageCode) {
    _preferences.setString('language', languageCode);
    setState(() {
      currentOption = languageCode == 'en_US' ? 'English' : 'বাংলা';
    });
    Get.back(); // Close the bottom sheet
    Get.updateLocale(Locale.fromSubtags(languageCode: languageCode));
  }
}

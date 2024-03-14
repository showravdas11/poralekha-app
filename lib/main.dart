import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:poralekha_app/screens/Language/language.dart';
import 'package:poralekha_app/screens/Splash/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  void _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    String savedLanguage = _preferences.getString('language') ?? 'en_US';
    Get.updateLocale(Locale.fromSubtags(languageCode: savedLanguage));
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 240, 248, 255),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 240, 246, 255),
        primaryColor: const Color.fromARGB(255, 240, 248, 255),
      ),
      home: SplashScreen(),
    );
  }
}

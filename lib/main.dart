import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/Language/language.dart';
import 'package:poralekha_app/screens/Splash/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('en', 'US'),
      translations: Languages(),
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 240, 248, 255),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 240, 248, 255),
          primaryColor: const Color.fromARGB(255, 240, 248, 255)),
      home: const SplashScreen(),
    );
  }
}

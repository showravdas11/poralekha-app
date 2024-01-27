import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poralekha_app/screens/Splash/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 240, 248, 255),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 240, 246, 255),
          useMaterial3: true,
          primaryColor: const Color.fromARGB(255, 240, 248, 255)),
      home: const SplashScreen(),
    );
  }
}

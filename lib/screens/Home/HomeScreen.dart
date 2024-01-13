import 'package:flutter/material.dart';
import 'package:poralekha_app/screens/Home/BookList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BookListScreen();
  }
}

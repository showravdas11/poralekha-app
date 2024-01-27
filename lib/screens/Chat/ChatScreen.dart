import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/screens/Login/LoginScreen.dart';
import 'package:poralekha_app/screens/Profile/widget/UtilitiesSection.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      // Your chat screen content goes here
      child: Center(
        child: Text("Chat Screen"),
      ),
    );
  }
}

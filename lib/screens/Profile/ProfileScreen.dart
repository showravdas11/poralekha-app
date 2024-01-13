import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poralekha_app/screens/Login/LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Your profile screen content goes here
      child: Center(
        child: TextButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (contex) => LoginScreen()));
              });
            },
            child: Text("Logout",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ),
    );
  }
}

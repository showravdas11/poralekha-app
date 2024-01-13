import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poralekha_app/bottomNavBar/bottom_nav_bar.dart';
import 'package:poralekha_app/screens/loginScreen/login_screen.dart';
import 'package:poralekha_app/screens/select_class.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  Widget build(BuildContext context) {
    return checkuser();
  }

  checkuser() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return BottomNavBar();
    } else {
      // Return a widget, for example, a Material widget containing LoginScreen
      return Material(
        child: LoginScreen(),
      );
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poralekha_app/MainScreen/MainScreen.dart';
import 'package:poralekha_app/screens/ClassList/ClassListScreen.dart';
import 'package:poralekha_app/screens/Login/LoginScreen.dart';
import 'package:poralekha_app/screens/OnBoard/OnBoardScreen.dart';
import 'package:poralekha_app/screens/WaitingScreen/WaitingScreen.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startFadeOut();
  }

  void _startFadeOut() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        opacity = 0.0;
      });

      Future.delayed(const Duration(seconds: 1), () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.emailVerified) {
          final userData = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (userData['class'] == null || userData['class'] == "") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ClassListScreen()),
            );
          } else {
            print("My user datatata ${userData}");
            print("fjslfjlfjslkfj");
            if (userData['isApproved'] == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WaitingScreen()),
              );
            }
          }
        } else {
          // Return a widget, for example, a Material widget containing LoginScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardScreen()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.canvousColor,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/poralekha-splash-screen-logo.png",
                width: 160,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SpinKitThreeBounce(
                  size: 30.0,
                  itemBuilder: (BuildContext context, int index) {
                    List<Color> colors = [
                      Color(0xFF5CB3FF),
                      Color(0xFF7E59FD),
                      Color.fromARGB(255, 0, 0, 0),
                    ];

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: colors[index % colors.length],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

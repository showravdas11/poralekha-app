import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poralekha_app/screens/gettingStarted/getting_started.dart';
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
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        opacity = 0.0;
      });

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GettingStartedScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.WhiteColor,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/poralekha-splash.png",
                width: 120,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  itemBuilder: (BuildContext context, int index) {
                    List<Color> colors = [
                      Color.fromARGB(255, 231, 82, 119),
                      Color.fromARGB(255, 69, 90, 181),
                      Color.fromARGB(255, 60, 183, 244),
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

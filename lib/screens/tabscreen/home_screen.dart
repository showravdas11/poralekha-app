import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:poralekha_app/components/home_banner.dart';
import 'package:poralekha_app/screens/splash_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  List imgData = [
    "assets/images/mathematics.png",
    "assets/images/ict.png",
    "assets/images/physics.png",
    "assets/images/chemistry.png",
    "assets/images/biology.png",
    "assets/images/english.png",
  ];

  List titles = [
    "Mathematics",
    "ICT",
    "Physics",
    "Chemistry",
    "Biology",
    "English",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const HomeBanner(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Expolore Categories",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 78, 116, 249),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 0,
                              crossAxisSpacing: 0),
                      shrinkWrap: true,
                      itemCount: imgData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(14, 0, 0, 0),
                                    spreadRadius: 1,
                                    blurRadius: 10)
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    imgData[index],
                                    width: 100,
                                  ),
                                  Text(
                                    titles[index],
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}

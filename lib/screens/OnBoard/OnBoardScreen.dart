import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/Login/LoginScreen.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  late Stream<QuerySnapshot> _usersStream;
  final auth = FirebaseAuth.instance;

  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .snapshots();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w600,
                        fontFamily: "FontMain",
                        color: MyTheme.buttonColor,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: demo_data.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnboardContent(
                    image: demo_data[index].image,
                    title: demo_data[index].title,
                    description: demo_data[index].description,
                  ),
                ),
              ),
              if (_pageIndex == 0) // Show only on the first screen
                // LanguageSelection(),
                SizedBox(
                  height: 20,
                ),
              Row(
                children: [
                  ...List.generate(
                    demo_data.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.01),
                      child: DotIndicator(isActive: index == _pageIndex),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.18,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: MyTheme.buttonColor,
                      ),
                      onPressed: () {
                        if (_pageIndex == demo_data.length - 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: SvgPicture.asset(
                        "assets/images/reshot-icon-arrow-right-LA2EJ39WDT.svg",
                        color: Colors.white,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatefulWidget {
  const DotIndicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  final bool isActive;

  @override
  State<DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<DotIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: widget.isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: widget.isActive
            ? MyTheme.buttonColor
            : MyTheme.buttonColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class Onboard {
  final String image, title, description;

  Onboard({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<Onboard> demo_data = [
  Onboard(
    image: "assets/images/onb4.png",
    title: "Education For All",
    description: "Education is the movement from darkness to light.",
  ),
  Onboard(
    image: "assets/images/onb3.png",
    title: "Discover Your Power",
    description:
        "Education is the key to unlocking the world, a passport to freedom.",
  ),
  Onboard(
    image: "assets/images/onb1.png",
    title: "Findout Your Creativity",
    description:
        "Creativity is the power to connect the seemingly unconnected.",
  )
];

class OnboardContent extends StatefulWidget {
  const OnboardContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String image, title, description;

  @override
  State<OnboardContent> createState() => _OnboardContentState();
}

class _OnboardContentState extends State<OnboardContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Image.asset(
          widget.image,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
        Spacer(),
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.08,
            fontWeight: FontWeight.bold,
            fontFamily: "FontMain",
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Text(
          widget.description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Spacer(),
      ],
    );
  }
}

// class LanguageSelection extends StatefulWidget {
//   const LanguageSelection({Key? key}) : super(key: key);

//   @override
//   State<LanguageSelection> createState() => _LanguageSelectionState();
// }

// class _LanguageSelectionState extends State<LanguageSelection>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;

//   bool isEnglishSelected = true;
//   bool isRunningSelected = true;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: Offset(0.6, 0),
//     ).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Container(
//       width: screenWidth * 0.6,
//       padding: EdgeInsets.symmetric(
//           vertical: screenHeight * 0.010, horizontal: screenWidth * 0.03),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(screenWidth * 0.02),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               Get.updateLocale(const Locale('en', 'US'));
//               setState(() {
//                 isRunningSelected = true;
//                 _animationController.reverse();
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: isRunningSelected
//                   ? MyTheme.buttonColor
//                   : MyTheme.buttonColor.withOpacity(0.6),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(screenWidth * 0.02),
//               ),
//             ),
//             child: Text(
//               "English",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: screenWidth * 0.04,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 7,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.updateLocale(const Locale('bd', 'BAN'));
//               setState(() {
//                 isRunningSelected = false;
//                 _animationController.forward();
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: isRunningSelected
//                   ? MyTheme.buttonColor.withOpacity(0.6)
//                   : MyTheme.buttonColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(screenWidth * 0.02),
//               ),
//             ),
//             child: Text(
//               "বাংলা",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: screenWidth * 0.04,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           // SlideTransition(
//           //   position: _slideAnimation,
//           //   child: Container(
//           //     height: 40,
//           //     width: 4,
//           //     color: MyTheme.buttonColor,
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

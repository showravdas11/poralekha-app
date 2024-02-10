import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:poralekha_app/utils/check_user.dart';

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

  // @override
  // void initState() {

  //   super.initState();
  // }

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckUser()),
                      );
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: "FontMain",
                          color: MyTheme.buttonColor),
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
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
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

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: isActive
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
    image: "assets/images/onb2.png",
    title: "Learn Form Home",
    description:
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia molestiae quas",
  ),
  Onboard(
    image: "assets/images/onb3.png",
    title: "Discover Your Power",
    description:
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia molestiae quas",
  ),
  Onboard(
    image: "assets/images/onb1.png",
    title: "Findout Your Creativity",
    description:
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia molestiae quas",
  )
];

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Image.asset(
          image,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
        Spacer(),
        Text(
          title,
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
          description,
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
        Spacer(),
      ],
    );
  }
}

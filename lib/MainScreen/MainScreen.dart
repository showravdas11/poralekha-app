import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/screens/Chat/ChatListScreen.dart';
import 'package:poralekha_app/screens/ClassList/ClassListScreen.dart';
import 'package:poralekha_app/screens/Home/HomeScreen.dart';
import 'package:poralekha_app/screens/Profile/ProfileScreen.dart';
import 'package:poralekha_app/screens/SubjectList/subject_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    ChatListScreen(),
    const SubjectListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
            )
          ],
        ),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: const Color.fromARGB(255, 78, 116, 249),
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [
              GButton(
                icon: Iconsax.home,
                text: "Home",
              ),
              GButton(
                icon: Iconsax.message,
                text: "Chat",
              ),
              GButton(
                icon: Iconsax.book,
                text: "Book",
              ),
              GButton(
                icon: Iconsax.user,
                text: "Profile",
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        )),
      ),
    );
  }
}
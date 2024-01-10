import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

import 'package:poralekha_app/components/home_banner.dart';

import 'package:poralekha_app/screens/tabscreen/book_screen.dart';
import 'package:poralekha_app/screens/tabscreen/chat_screen.dart';
import 'package:poralekha_app/screens/tabscreen/home_screen.dart';
import 'package:poralekha_app/screens/tabscreen/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ChatScreen(),
    BookScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
              activeColor: Colors.redAccent,
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
      ),
    );
  }
}

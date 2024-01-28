import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:poralekha_app/screens/Home/My_Drawer_Header.dart';
import 'package:poralekha_app/screens/Home/My_Drawer_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Mina',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Class Five'.tr,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/profile.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.amber,
                image: const DecorationImage(
                  image: AssetImage('assets/images/english-banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 126, 89, 253),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: const Drawer(
        backgroundColor: Color.fromARGB(255, 240, 248, 255),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyDrawerHeader(),
              MyDrawerList(),
            ],
          ),
        ),
      ),
    );
  }
}

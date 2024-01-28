import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/SubjectList/subject_list_screen.dart';

class ClassListScreen extends StatefulWidget {
  const ClassListScreen({Key? key}) : super(key: key);

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  List<String> imgData = [
    "assets/images/HSC.png",
    "assets/images/ten.png",
    "assets/images/nine.png",
    "assets/images/eight.png",
    "assets/images/seven.png",
    "assets/images/six.png",
    "assets/images/five.png",
  ];

  List<String> titles = [
    "HSC",
    "Class Ten",
    "Class Nine",
    "Class Eight",
    "Class Seven",
    "Class Six",
    "Class Five",
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Your Class",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          shrinkWrap: true,
          itemCount: imgData.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectListScreen(),
                  ),
                );
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(14, 0, 0, 0),
                      spreadRadius: 1,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        imgData[index],
                        width:
                            screenWidth * 0.20, // Adjust the factor as needed
                      ),
                      Text(
                        titles[index],
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.04, // Adjust the factor as needed
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

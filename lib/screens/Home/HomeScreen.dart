import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/Home/My_Drawer_Header.dart';
import 'package:poralekha_app/screens/Home/My_Drawer_list.dart';
import 'package:intl/intl.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:poralekha_app/widgets/HomeBanner.dart';
import 'package:poralekha_app/widgets/LecturesCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState(documentId: '');
}

class _HomeScreenState extends State<HomeScreen> {
  String _state = "running";
  late Stream<QuerySnapshot> _lectureStream;

  final String documentId;

  _HomeScreenState({required this.documentId});

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
    final DateFormat timeFormatter = DateFormat('hh:mm a');
    final String formattedDate = dateFormatter.format(now);
    final String formattedTime = timeFormatter.format(now);
    print("Now formatted time $formattedDate $formattedTime");
    _lectureStream = FirebaseFirestore.instance.collection('lecture').snapshots();
  }

  bool isRunningLecture(String date, String startTime, String endTime) {
    try {
      final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
      final DateFormat timeFormatter = DateFormat('hh:mm a');

      DateTime parsedDate = dateFormatter.parse(date);
      DateTime today = DateTime.now();

      if (parsedDate.isAtSameMomentAs(DateTime(today.year, today.month, today.day))) {
        // final DateTime startDateTime = timeFormatter.parse(startTime);
        // final DateTime endDateTime = timeFormatter.parse(endTime);
        // DateTime now = DateTime.now();
        // return now.isAfter(startDateTime) && now.isBefore(endDateTime);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("object");
      print('Error occurred: $e');
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Mina',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Class Five'.tr,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              const Padding(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeBanner(),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: Text(
                  "Class Lectures",
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015,
                    horizontal: screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_state != "running") {
                          setState(() {
                            _state = "running";
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _state == "running"
                            ? MyTheme.buttonColor
                            : MyTheme.buttonColor.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(screenWidth * 0.02),
                        ),
                      ),
                      child: Text(
                        "Running",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_state != "upcoming") {
                          setState(() {
                            _state = "upcoming";
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _state == "running"
                            ? MyTheme.buttonColor.withOpacity(0.6)
                            : MyTheme.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(screenWidth * 0.02),
                        ),
                      ),
                      child: Text(
                        "Upcoming",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              StreamBuilder(
                stream: _lectureStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something Went Wrong"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No Data Found"),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final lectureData = snapshot.data!.docs[index].data()
                      as Map<String, dynamic>;
                      bool isRunning = isRunningLecture(lectureData['date'], lectureData['startTime'], lectureData['endTime']);
                      if ((isRunning && _state == 'running') || (!isRunning && _state == 'upcoming')) {
                        return Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.01),
                          child: LectureCard(
                            lectureData: lectureData,
                            documentId: documentId,
                            screen: "home",
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      drawer: const Drawer(
        backgroundColor: Color.fromARGB(255, 240, 248, 255),
        child: Column(
          children: [
            MyDrawerHeader(),
            MyDrawerList(),
          ],
        ),
      ),
    );
  }
}
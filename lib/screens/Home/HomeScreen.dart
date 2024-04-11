import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:poralekha_app/screens/Home/My_Drawer_Header.dart';
import 'package:poralekha_app/screens/Home/My_Drawer_list.dart';
import 'package:poralekha_app/screens/Profile/ProfileScreen.dart';
import 'package:poralekha_app/screens/UpdateProfileScreen/UpdateProfile.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:poralekha_app/widgets/HomeBanner.dart';
import 'package:poralekha_app/widgets/LecturesCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _state = "upcoming";
  late Stream<QuerySnapshot> _lectureStream;
  late SharedPreferences _preferences;
  bool? isAdmin = false;
  String? name = "";
  String? className = "";
  String? img = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _getDataFromSharedPreferences();
    _lectureStream =
        FirebaseFirestore.instance.collection('lecture').snapshots();
  }

  Future<void> _getDataFromSharedPreferences() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = _preferences.getBool('isAdmin');
      name = _preferences.getString('name');
      className = _preferences.getString('class');
      img = _preferences.getString('img');
    });
  }

  bool isRunningLecture(String date, String startTime, String endTime) {
    try {
      final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

      DateTime parsedDate = dateFormatter.parse(date);
      DateTime today = DateTime.now();

      if (parsedDate
          .isAtSameMomentAs(DateTime(today.year, today.month, today.day))) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

        DateFormat dateFormat = DateFormat('h:mm a');
        DateTime parsedStartTime = dateFormat.parse(startTime);
        DateTime parsedEndTime = dateFormat.parse(endTime);

        DateFormat twentyFourHourFormat = DateFormat('HH:mm:ss');
        String formattedStartTime =
            twentyFourHourFormat.format(parsedStartTime);
        String formattedEndTime = twentyFourHourFormat.format(parsedEndTime);

        DateTime startDateTime =
            DateTime.parse("$formattedDate $formattedStartTime");
        DateTime endDateTime =
            DateTime.parse("$formattedDate $formattedEndTime");

        if (startDateTime.isBefore(DateTime.now()) &&
            endDateTime.isAfter(DateTime.now())) {
          return true;
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            isAdmin == true
                ? IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      print("drawer opening");
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  )
                : Image.asset(
                    "assets/images/poralekha-splash-screen-logo.png",
                    height: Get.height * 0.03,
                  )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      className ?? "".tr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Get.to(ProfileScreen());
                  },
                  child: CircleAvatar(
                    backgroundImage: img != null || img != ""
                        ? NetworkImage(img ?? "")
                        : const AssetImage('assets/images/user.png')
                            as ImageProvider,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      drawer: isAdmin == true ? SizedBox(
        width: Get.width * 0.60,
        child: const Drawer(
          backgroundColor: Color.fromARGB(255, 240, 248, 255),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MyDrawerHeader(),
              MyDrawerList(),
            ],
          ),
        ),
      ) : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeBanner(),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Text(
                  "Class Lectures".tr,
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015,
                  horizontal: screenWidth * 0.03,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_state != "upcoming") {
                          setState(() {
                            _state = "upcoming";
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _state == "upcoming"
                            ? MyTheme.buttonColor
                            : MyTheme.buttonColor.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                        ),
                      ),
                      child: Text(
                        "Upcoming".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_state != "running") {
                          setState(() {
                            _state = "running";
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _state == "upcoming"
                            ? MyTheme.buttonColor.withOpacity(0.6)
                            : MyTheme.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                        ),
                      ),
                      child: Text(
                        "Running".tr,
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
              SizedBox(height: screenHeight * 0.01),
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
                      bool isRunning = isRunningLecture(lectureData['date'],
                          lectureData['startTime'], lectureData['endTime']);
                      if ((isRunning && _state == 'running') ||
                          (!isRunning && _state == 'upcoming')) {
                        return Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.01),
                          child: LectureCard(
                            lectureData: lectureData,
                            documentId: "",
                            screen: "home",
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

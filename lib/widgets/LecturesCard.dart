import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/link.dart';

class LectureCard extends StatefulWidget {
  const LectureCard({
    Key? key,
    required this.lectureData,
  }) : super(key: key);

  final Map<String, dynamic> lectureData;

  @override
  State<LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<LectureCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.9; // Adjust as needed
    final cardHeight = screenHeight * 0.25; // Adjust as needed
    final imageWidth = cardHeight * 0.5; // Adjust as needed

    return Card(
      // elevation: 3,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      // color: Color(0xFFFBFBFB), // Set card background color
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFFBFBFB),
            borderRadius: BorderRadius.circular(10.0)),

        width: cardWidth,
        height: cardHeight,
        padding: EdgeInsets.all(
            screenWidth * 0.03), // Adjust padding based on screen width
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
// Add spacing between icon and text
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTextWithIcon(
                    icon: Iconsax.book,
                    text: "Topic: ${widget.lectureData["topic"]}",
                    screenWidth: screenWidth,
                  ),
                  SizedBox(
                      height: screenHeight *
                          0.01), // Adjust spacing based on screen height
                  buildTextWithIcon(
                    icon: Iconsax.user, // Add your desired icon here
                    text: "Teacher: ${widget.lectureData["teacherName"]}",
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  buildTextWithIcon(
                    icon: Iconsax.calendar_add, // Add your desired icon here
                    text: "Date: ${widget.lectureData["date"]}",
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  buildTextWithIcon(
                    icon: Iconsax.watch, // Add your desired icon here
                    text:
                        "Time: ${widget.lectureData["startTime"]}-${widget.lectureData["endTime"]}",
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    widget.lectureData["linkType"] == "meet"
                        ? "assets/images/google-meet.png"
                        : "assets/images/zoom.png",
                    width: imageWidth,
                  ),
                  Link(
                    target: LinkTarget.blank,
                    uri: Uri.parse(widget.lectureData["link"]),
                    builder: (context, classLink) => ElevatedButton(
                      onPressed: classLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5B37B7), // Set button color
                        foregroundColor: Colors.white, // Set text color
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth *
                              0.02, // Adjust padding based on screen width
                          vertical: screenHeight *
                              0.01, // Adjust padding based on screen height
                        ),
                      ),
                      child: Text(
                        'Join Now',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontFamily: "FontMain",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextWithIcon({
    required IconData icon,
    required String text,
    required double screenWidth,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        SizedBox(
            width: screenWidth * 0.03), // Add spacing between icon and text
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize:
                  screenWidth * 0.04, // Adjust font size based on screen width
              fontWeight: FontWeight.w500,
              color: Colors.black, // Set text color
              fontFamily: "FontMain",
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:url_launcher/link.dart';

class LectureCard extends StatefulWidget {
  const LectureCard({
    Key? key,
    required this.lectureData,
    required this.screen,
  }) : super(key: key);

  final Map<String, dynamic> lectureData;
  final String screen;

  @override
  State<LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<LectureCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.9;
    final cardHeight = screenHeight * 0.25;
    final imageWidth = cardHeight * 0.5;

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
        padding: EdgeInsets.all(screenWidth * 0.03),
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
                  SizedBox(height: screenHeight * 0.01),
                  buildTextWithIcon(
                    icon: Iconsax.user,
                    text: "Teacher: ${widget.lectureData["teacherName"]}",
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  buildTextWithIcon(
                    icon: Iconsax.calendar_add,
                    text: "Date: ${widget.lectureData["date"]}",
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  buildTextWithIcon(
                    icon: Iconsax.watch,
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
                children: [
                  Image.asset(
                    widget.lectureData["linkType"] == "meet"
                        ? "assets/images/google-meet.png"
                        : "assets/images/zoom.png",
                    width: imageWidth,
                  ),
                  widget.screen == "home"
                      ? Link(
                          target: LinkTarget.blank,
                          uri: Uri.parse(widget.lectureData["link"]),
                          builder: (context, classLink) => ElevatedButton(
                            onPressed: classLink,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyTheme.buttonColor,
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.01,
                              ),
                            ),
                            child: const Text(
                              'Join Now',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontFamily: "FontMain",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.buttonColor,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.01,
                            ),
                          ),
                          child: Text(
                            'Edit info',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontFamily: "FontMain",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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
        SizedBox(width: screenWidth * 0.03),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: "FontMain",
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

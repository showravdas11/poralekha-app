import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class HomeClassCard extends StatefulWidget {
  const HomeClassCard({
    super.key,
    required this.name,
    required this.Class,
    required this.teacherName,
    required this.linkType,
    required this.link,
    this.icon,
  });

  final IconData? icon;
  final String name, Class, teacherName, linkType, link;

  @override
  State<HomeClassCard> createState() => _HomeClassCardState();
}

class _HomeClassCardState extends State<HomeClassCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7E59FD),
                  Color(0xFF5B37B7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Topic Name: ${widget.name}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: "FontMain",
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Class Name: ${widget.Class}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: "FontMain",
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Teacher Name: ${widget.teacherName}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: "FontMain",
                        ),
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
                          widget.linkType == "meet"
                              ? "assets/images/google-meet.png"
                              : "assets/images/zoom.png",
                          width: 30,
                        ),
                        Link(
                          target: LinkTarget.blank,
                          uri: Uri.parse(widget.link),
                          builder: (context, classLink) => ElevatedButton(
                            onPressed: classLink,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF5B37B7),
                              foregroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              elevation: 5, // elevation
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // rounded corners
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5), // button padding
                            ),
                            child: Text(
                              'Join Now',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "FontMain",
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

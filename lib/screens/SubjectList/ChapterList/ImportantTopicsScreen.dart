import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportantTopicScreen extends StatefulWidget {
  final String documentId;
  final List<dynamic> topics;

  const ImportantTopicScreen({
    Key? key,
    required this.documentId,
    required this.topics,
  }) : super(key: key);

  @override
  State<ImportantTopicScreen> createState() => _ImportantTopicScreenState();
}

class _ImportantTopicScreenState extends State<ImportantTopicScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.topics.map((topic) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.1, // Adjust height as needed
          width:
              MediaQuery.of(context).size.width * 0.9, // Adjust width as needed
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height *
                  0.01), // Adjust margin as needed
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      // Image.asset(
                      //   'assets/images/Bookgif.gif',
                      //   width: 40,
                      //   height: 40,
                      // ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          topic['topicName'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // String animationUrl = topic['animationUrl'];
                  String? animationUrl = topic['animationUrl'];
                  Get.defaultDialog(
                    title: 'Animation',
                    titleStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    titlePadding: const EdgeInsets.only(top: 10),
                    content: SizedBox(
                      height: 150,
                      width: 270,
                      child: Image.network(
                        animationUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                child: Text("Click Here".tr),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

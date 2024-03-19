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
    if (widget.topics.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.1),
          child: Text(
            'No topics available'.tr,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    } else {
      return Column(
        children: widget.topics.map((topic) {
          return Container(
            height: Get.height * 0.10,
            width: double.infinity,
            // margin: EdgeInsets.symmetric(
            //     vertical: MediaQuery.of(context).size.height *
            //         0.01), // Adjust margin as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Card(
              elevation: 0.5,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Expanded(
                          child: Text(
                            topic['topicName'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
            ),
          );
        }).toList(),
      );
    }
  }
}

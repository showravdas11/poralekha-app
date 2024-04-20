import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/screens/Chat/ChatScreen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _chatroomsStream;

  late String _id;
  late String name;
  late String Class;
  late bool isAdmin;

  @override
  void initState() {
    super.initState();
    loadChatRooms();
  }

  void loadChatRooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    _id = prefs.getString('_id') ?? "";
    name = prefs.getString('name') ?? "";
    Class = prefs.getString('class') ?? "";
    isAdmin = prefs.getBool('isAdmin') ?? false;
    if (authToken != null) {
      if (isAdmin) {
        setState(() {
          _chatroomsStream = FirebaseFirestore.instance
              .collection("chats")
              .orderBy('serial')
              .snapshots();
        });
      } else {
        print("hamar class ${Class}");
        setState(() {
          _chatroomsStream = FirebaseFirestore.instance
              .collection("chats")
              .where('name', isEqualTo: Class)
              .snapshots();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ChatRoomsStream: $_chatroomsStream');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chat Rooms'.tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _chatroomsStream,
          builder: (ctx,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (chatSnapshot.data == null || chatSnapshot.data!.docs.isEmpty) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // Show loader instead of "No chat rooms found"
            }
            final chatDocs = chatSnapshot.data!.docs;
            return ListView.builder(
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ChatScreen(chatDocs[index]['name']),
                    ),
                  );
                },
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatDocs[index].id)
                      .collection('messages')
                      .orderBy('createdAt', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Opacity(
                        opacity: 0.0,
                      );
                    }
                    final lastMessage = snapshot.data!.docs.first;
                    String lastMessageText = lastMessage['text'] ?? '';
                    final lastMessageTime = lastMessage['createdAt'] ?? '';
                    final formattedTime = DateFormat.jm().format(
                      (lastMessageTime as Timestamp).toDate(),
                    );

                    if (lastMessageText.length > 20) {
                      lastMessageText =
                          '${lastMessageText.substring(0, 20)}...';
                    }

                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: AssetImage(
                              'assets/images/${chatDocs[index]['image']}',
                            ),
                          ),
                          title: Text(
                            chatDocs[index]['name'],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(lastMessageText),
                          trailing: Text(formattedTime),
                        ),
                        Divider(
                          height: 0,
                          thickness: 0.5,
                          color: Colors.grey[300],
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

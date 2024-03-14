import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poralekha_app/screens/Chat/ChatScreen.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _chatroomsStream;

  @override
  void initState() {
    super.initState();
    loadChatRooms();
  }

  void loadChatRooms() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final isAdmin = userData.get('isAdmin') as bool;
      if (isAdmin) {
        setState(() {
          _chatroomsStream = FirebaseFirestore.instance
              .collection("chats")
              .orderBy('serial')
              .snapshots();
        });
      } else {
        final className = userData.get('class') as String;
        setState(() {
          _chatroomsStream = FirebaseFirestore.instance
              .collection("chats")
              .where('name', isEqualTo: className)
              .snapshots();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Chat Rooms',
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
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatDocs[index].id)
                      .collection('messages')
                      .orderBy('createdAt', descending: true)
                      .limit(1)
                      .get()
                      .then((value) => value.docs.first),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Opacity(
                        opacity: 0.0,
                      );
                    }
                    final lastMessage = snapshot.data!;
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

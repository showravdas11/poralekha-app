import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poralekha_app/screens/Chat/ChatScreen.dart';

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
          _chatroomsStream =
              FirebaseFirestore.instance.collection("chats").snapshots();
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

  // final List<String> avatarImages = [
  //   'assets/images/six.png',
  //   'assets/images/seven.png',
  //   'assets/images/eight.png',
  //   'assets/images/nine.png',
  //   'assets/images/ten.png',
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
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
              return Center(child: CircularProgressIndicator());
            }
            if (chatSnapshot.data == null || chatSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('No chat rooms found.'));
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
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: NetworkImage(
                          chatDocs[index]['image'],
                        ),
                      ),
                      title: Text(chatDocs[index]['name']),
                      subtitle: Text('Last message'),
                      trailing: Text('11:30 PM'),
                    ),
                    Divider(
                      height: 0,
                      thickness: 0.5,
                      color: Colors.grey[300],
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomName;

  ChatScreen(this.chatRoomName);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  bool _isSending = false;
  String _msg = "";
  DocumentSnapshot<Map<String, dynamic>>? userData;
  ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _perPage = 15;
  List<DocumentSnapshot> _messages = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _getMessages();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _getMessages();
    }
  }

  void _getMessages() async {
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    final collectionRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatRoomName)
        .collection('messages');

    QuerySnapshot querySnapshot;
    if (_messages.isEmpty) {
      querySnapshot = await collectionRef
          .orderBy('createdAt', descending: true)
          .limit(_perPage)
          .get();
    } else {
      querySnapshot = await collectionRef
          .orderBy('createdAt', descending: true)
          .startAfterDocument(_messages.last)
          .limit(_perPage)
          .get();
    }

    setState(() {
      _isLoadingMore = false;
      _messages.addAll(querySnapshot.docs);
    });
  }

  void _sendMessage() async {
    final messageText = _messageController.text.trim();

    if (messageText.isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    setState(() {
      _isSending = true;
    });

    try {
      DocumentReference messageRef = await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatRoomName)
          .collection('messages')
          .add({
        'text': messageText,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'name': userData['name'],
      });

      DocumentSnapshot sentMessageSnapshot = await messageRef.get();

      setState(() {
        _messages.insert(0, sentMessageSnapshot);
        _isSending = false;
        _msg = "";
      });
    } catch (e) {
      print("Error adding message: $e");
      setState(() {
        _isSending = false;
      });
    }

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEAE2),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.chatRoomName.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                NetworkImage("https://cdn.wallpapersafari.com/4/11/WofyVJ.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: _messages.length + 1,
                  itemBuilder: (ctx, index) {
                    if (index < _messages.length) {
                      return MessageBubble(
                        _messages[index]['text'],
                        _messages[index]['name'],
                        _messages[index]['userId'] ==
                            FirebaseAuth.instance.currentUser!.uid,
                        _messages[index]['createdAt'],
                        isSending: _isSending && index == 0,
                        key: ValueKey(_messages[index].id),
                      );
                    } else {
                      return _isLoadingMore
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox();
                    }
                  },
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) {
                        _sendMessage();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatefulWidget {
  final String message;
  final String username;
  final bool belongsToCurrentUser;
  final Timestamp timestamp;
  final bool isSending;

  MessageBubble(
    this.message,
    this.username,
    this.belongsToCurrentUser,
    this.timestamp, {
    required this.isSending,
    Key? key,
  }) : super(key: key);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: widget.belongsToCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: BorderRadius.only(
              topLeft: widget.belongsToCurrentUser
                  ? const Radius.circular(24)
                  : const Radius.circular(0),
              topRight: widget.belongsToCurrentUser
                  ? const Radius.circular(0)
                  : const Radius.circular(24),
              bottomLeft: const Radius.circular(24),
              bottomRight: const Radius.circular(24),
            ),
            color: widget.belongsToCurrentUser
                ? const Color(0xFFDCF8C6)
                : Colors.white,
            elevation: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.belongsToCurrentUser)
                    Text(
                      widget.username,
                      style: const TextStyle(
                        color: Color(0xFF128C7E),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 5),
                  Text(
                    widget.message,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  if (widget.isSending)
                    Text(
                      'Sending...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 5),
                  Text(
                    _formatTimestamp(),
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp() {
    DateTime dateTime = widget.timestamp.toDate();
    String formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }
}

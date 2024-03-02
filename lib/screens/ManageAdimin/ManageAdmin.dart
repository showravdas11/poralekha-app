import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageAdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Admin'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> users = snapshot.data!.docs;

          // Get the current user's ID
          String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index].data() as Map<String, dynamic>;

              // Check if the user is the current user, and skip if so
              if (user['email'] == currentUserEmail) {
                return const SizedBox.shrink();
              }

              return ApproveUserTile(
                name: user['name'] ?? 'Name',
                email: user['email'] ?? 'Email',
                role: user['role'] ?? 'Role',
                isAdmin: user['isAdmin'] ?? false,
                onPressed: () {
                  _updateUserApproval(users[index].id, !user['isAdmin']);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _updateUserApproval(String userId, bool isAdmin) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
          'isAdmin': isAdmin,
        })
        .then((_) {})
        .catchError((error) {});
  }
}

class ApproveUserTile extends StatefulWidget {
  final String name;
  final String email;
  final String role;
  final bool isAdmin;
  final VoidCallback onPressed;

  ApproveUserTile({
    required this.name,
    required this.email,
    required this.role,
    required this.isAdmin,
    required this.onPressed,
  });

  @override
  _ApproveUserTileState createState() => _ApproveUserTileState();
}

class _ApproveUserTileState extends State<ApproveUserTile> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = !_isTapped;
        });
        widget.onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: _isTapped
                ? Matrix4.diagonal3Values(0.95, 0.95, 1.0)
                : Matrix4.identity(),
            decoration: BoxDecoration(
              gradient: widget.isAdmin
                  ? LinearGradient(
                      colors: [Colors.red.withOpacity(0.8), Colors.red],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${widget.name}',
                        style: TextStyle(
                          color: widget.isAdmin ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email: ${widget.email}',
                        style: TextStyle(
                          color: widget.isAdmin ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.onPressed,
                  icon: Icon(
                    widget.isAdmin ? Icons.remove_circle : Icons.add_circle,
                    color: widget.isAdmin ? Colors.white : Colors.green,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

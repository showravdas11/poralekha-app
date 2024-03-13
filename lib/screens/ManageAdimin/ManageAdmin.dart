import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class ManageAdminScreen extends StatefulWidget {
  @override
  State<ManageAdminScreen> createState() => _ManageAdminScreenState();
}

class _ManageAdminScreenState extends State<ManageAdminScreen> {
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
          String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index].data() as Map<String, dynamic>;

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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      colors: [Colors.green.withOpacity(0.8), Colors.green],
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
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.isAdmin ? Colors.red : MyTheme.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.isAdmin ? 'Revert' : 'Make Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isAdmin
                      ? Icons.admin_panel_settings
                      : Icons.person_add,
                  size: MediaQuery.of(context).size.width * 0.1,
                  color: widget.isAdmin ? Colors.red : Colors.green,
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                Text(
                  widget.isAdmin ? 'Revert Admin' : 'Make Admin',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width *
                        0.05, // Adjust font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.025),
                Text(
                  widget.isAdmin
                      ? 'Do you want to revert admin privileges?'
                      : 'Do you want to make this user an admin?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width *
                        0.04, // Adjust font size
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.onPressed();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

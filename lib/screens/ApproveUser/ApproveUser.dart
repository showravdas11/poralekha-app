import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class ApproveUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approve User".tr),
      ),
      body: ApproveUserList(),
    );
  }
}

class ApproveUserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<QueryDocumentSnapshot> users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index].data() as Map<String, dynamic>;

            return ApproveUserTile(
              name: user['name'] ?? 'Name',
              email: user['email'] ?? 'Email',
              role: user['role'] ?? 'Role',
              isApproved: user['isApproved'] ?? false,
              onPressed: () {
                _updateUserApproval(users[index].id);
              },
            );
          },
        );
      },
    );
  }

  void _updateUserApproval(String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isApproved': true,
    }).then((_) {
      print('User approval updated successfully.');
    }).catchError((error) {
      print('Failed to update user approval: $error');
    });
  }
}

class ApproveUserTile extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final bool isApproved;
  final VoidCallback onPressed;

  ApproveUserTile({
    required this.name,
    required this.email,
    required this.role,
    required this.isApproved,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Name: $name'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $email'),
            Text('Role: $role'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: isApproved ? null : onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey; // Color when button is disabled
                }
                return MyTheme.buttonColor; // Color when button is enabled
              },
            ),
          ),
          child: const Text('Approve',
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        contentPadding: EdgeInsets.all(16.0),
      ),
    );
  }
}

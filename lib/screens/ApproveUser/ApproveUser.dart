import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class ApproveUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Approve User".tr,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
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

            if (user['isAdmin'] == true) {
              return const SizedBox.shrink();
            }
            if (user['email'] == currentUserEmail) {
              return const SizedBox.shrink();
            }

            return ApproveUserTile(
              name: user['name'] ?? 'Name',
              email: user['email'] ?? 'Email',
              Class: user['class'] ?? 'Class',
              isApproved: user['isApproved'] ?? false,
              userId: users[index].id,
            );
          },
        );
      },
    );
  }
}

class ApproveUserTile extends StatelessWidget {
  final String name;
  final String email;
  final String Class;
  final bool isApproved;
  final String userId;

  ApproveUserTile({
    required this.name,
    required this.email,
    required this.Class,
    required this.isApproved,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ListTile(
        title: Text(
          '${'Name'.tr}: $name',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'E-mail'.tr}: $email'),
            Text('${'Class'.tr}: ${Class.tr}'),
          ],
        ),
        trailing: isApproved
            ? ElevatedButton(
                onPressed: () => _showConfirmationDialog(context, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Revert'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: () => _showConfirmationDialog(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Approve'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, bool isApproveAction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        isApproveAction
                            ? 'Confirm Approval'.tr
                            : 'Confirm Revert'.tr,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        isApproveAction
                            ? 'Do you want to approve this student?'.tr
                            : 'Do you want to revert the approval of this student?'
                                .tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              'No'.tr,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _updateUserApproval(isApproveAction);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              'Yes'.tr,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 16,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 20,
                    child: Icon(
                      isApproveAction ? Icons.check : Icons.undo,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateUserApproval(bool isApproved) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isApproved': isApproved,
    }).then((_) {
      print('User approval updated successfully.');
    }).catchError((error) {
      print('Failed to update user approval: $error');
    });
  }
}

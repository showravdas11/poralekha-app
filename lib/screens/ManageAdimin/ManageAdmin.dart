import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageAdminScreen extends StatefulWidget {
  const ManageAdminScreen({Key? key}) : super(key: key);

  @override
  State<ManageAdminScreen> createState() => _ManageAdminScreenState();
}

class _ManageAdminScreenState extends State<ManageAdminScreen> {
  late List<User> _users = [];
  int _currentPage = 1;
  int _itemsPerPage = 10;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    // print("my token daw pls ${authToken}");
    String apiUrl =
        'https://poralekha-server-chi.vercel.app/auth/all?page=$_currentPage&limit=$_itemsPerPage';

    try {
      var response = await get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        // print("my datatatatta paiaiai${data}");
        List<dynamic> userList = data["users"];
        _users = userList.map((userJson) => User.fromJson(userJson)).toList();
        setState(() {});
      } else {
        setState(() {});
      }
    } catch (e) {
      print('Error: $e');
      setState(() {});
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchPage(int page) async {
    _currentPage = page;
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Admins'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        return UserCard(user: _users[index]);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentPage > 1) ...[
                        InkWell(
                          onTap: () => fetchPage(_currentPage - 1),
                          child: Icon(Icons.arrow_back),
                        ),
                      ],
                      SizedBox(width: 20),
                      for (var i = 1; i <= 5; i++) ...[
                        InkWell(
                          onTap: () => fetchPage(i),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _currentPage == i
                                  ? MyTheme.buttonColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: _currentPage == i
                                    ? MyTheme.buttonColor
                                    : Colors.black,
                              ),
                            ),
                            child: Text(
                              i.toString(),
                              style: TextStyle(
                                color: _currentPage == i
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (_currentPage > 5) ...[
                        Text('...'),
                      ],
                      if (_currentPage > 5) ...[
                        InkWell(
                          onTap: () => fetchPage(_currentPage),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _currentPage == _currentPage
                                  ? Colors.blue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Text(
                              _currentPage.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () => fetchPage(_currentPage + 1),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class User {
  final String mobileNumber;
  final String name;
  bool isAdmin;

  User({required this.mobileNumber, required this.name, required this.isAdmin});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      mobileNumber: json['mobileNumber'],
      name: json['name'],
      isAdmin: json['isAdmin'],
    );
  }
}

class UserCard extends StatefulWidget {
  final User user;

  UserCard({required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text("Name: ${widget.user.name}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Phone: ${widget.user.mobileNumber}"),
            Text('Is Admin: ${widget.user.isAdmin ? 'Yes' : 'No'}'),
          ],
        ),
        trailing: ElevatedButton(
            onPressed: () {
              _showConfirmationDialog(context, widget.user);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.user.isAdmin ? Colors.red : MyTheme.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: widget.user.isAdmin
                ? Text(
                    'Revert',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  )
                : Text(
                    'Make Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  )),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Confirmation',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.user.isAdmin
                    ? 'Are you sure you want to revert admin privileges?'
                    : 'Do you want to make this user an admin?',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _changeAdminStatus(
                    context, user, widget.user.isAdmin ? "remove" : "add");
              },
              icon: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24.0,
              ),
              label: Text(
                'Yes',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.green,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.red,
                size: 24.0,
              ),
              label: Text(
                'No',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _changeAdminStatus(BuildContext context, User user, String type) async {
    final Map<String, dynamic> reqBody = {
      'mobileNumber': user.mobileNumber,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    final response = await post(
      Uri.parse('https://poralekha-server-chi.vercel.app/auth/${type}-admin'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
      body: jsonEncode(reqBody),
    );

    if (response.statusCode == 200) {
      setState(() {
        widget.user.isAdmin = (type == "add") ? true : false;
      });
      print("Admin Created");
    } else {
      print("Admin Not Created");
    }

    print("status code ${response.statusCode}");
    print("response body ${response.body}");
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/theme/myTheme.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

class AllStudent extends StatefulWidget {
  const AllStudent({Key? key});

  @override
  State<AllStudent> createState() => _AllStudentState();
}

class _AllStudentState extends State<AllStudent> {
  int _totalStudents = 0;
  int _totalPages = 0;
  bool _isLoading = true;
  bool _isError = false;
  int _currentPage = 1;
  List _students = [];

  Future<void> _loadStudents() async {
    final response = await http.get(Uri.parse(
        'https://poralekha-server-chi.vercel.app/api/data?page=$_currentPage&password=qwerty'));

    if (response.statusCode == 200) {
      var body = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        _students = body['students'] as List;
        _totalStudents = body['totalStudents'];
        _totalPages = body['totalPages'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "All Students".tr,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_isError)
            const Center(
              child: Text('Something went wrong. Please try again.'),
            ),
          if (!_isLoading && !_isError)
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "Total Student: $_totalStudents",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "FontMain",
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _students.length,
                    itemBuilder: (BuildContext context, int index) {
                      final student = _students[index] as Map<String, dynamic>;
                      final name = student['name'];
                      final mobileNumber = student['mobileNumber'];
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(name),
                          subtitle: Text(mobileNumber),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildPagination(),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    const visiblePages = 4; // Maximum number of visible page buttons
    final startPage = (_currentPage - (visiblePages ~/ 2))
        .clamp(1, _totalPages - visiblePages + 1);
    final endPage = (startPage + visiblePages - 1).clamp(1, _totalPages);

    List<Widget> pageButtons = [];

    if (startPage > 2) {
      pageButtons.add(_PageButton(
        pageNumber: 1,
        currentPage: _currentPage,
        totalPages: _totalPages,
        onPressed: () {
          if (_currentPage != 1) {
            setState(() {
              _currentPage = 1;
              _isLoading = true;
            });
            _loadStudents();
          }
        },
      ));
      pageButtons.add(const Text(
        '...',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    for (var i = startPage; i <= endPage; i++) {
      if (i > 0 && i <= _totalPages) {
        pageButtons.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: _PageButton(
              pageNumber: i,
              currentPage: _currentPage,
              totalPages: _totalPages,
              onPressed: () {
                if (_currentPage != i) {
                  setState(() {
                    _currentPage = i;
                    _isLoading = true;
                  });
                  _loadStudents();
                }
              },
            ),
          ),
        );
      }
    }

    if (endPage < _totalPages - 1) {
      pageButtons.add(const Text(
        '...',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    if (endPage < _totalPages) {
      pageButtons.add(_PageButton(
        pageNumber: _totalPages,
        currentPage: _currentPage,
        totalPages: _totalPages,
        onPressed: () {
          if (_currentPage != _totalPages) {
            setState(() {
              _currentPage = _totalPages;
              _isLoading = true;
            });
            _loadStudents();
          }
        },
      ));
    }

    // Arrow buttons for previous and next page
    pageButtons.insert(
      0,
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _currentPage > 1
            ? () {
                setState(() {
                  _currentPage--;
                });
              }
            : null,
      ),
    );

    pageButtons.add(
      IconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: _currentPage < _totalPages
            ? () {
                setState(() {
                  _currentPage++;
                });
              }
            : null,
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pageButtons,
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final int pageNumber;
  final int currentPage;
  final int totalPages;
  final VoidCallback onPressed;

  const _PageButton({
    required this.pageNumber,
    required this.currentPage,
    required this.totalPages,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentPage = pageNumber == currentPage;

    final double paddingSize =
        MediaQuery.of(context).size.width > 600 ? 12.0 : 8.0;

    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCurrentPage ? MyTheme.buttonColor : Colors.transparent,
          border: Border.all(
            color: MyTheme.buttonColor,
            width: isCurrentPage ? 0 : 1,
          ),
        ),
        padding: EdgeInsets.all(paddingSize),
        child: Text(
          '$pageNumber',
          style: TextStyle(
            color: isCurrentPage ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

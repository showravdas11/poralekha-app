import 'package:flutter/material.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poralekha_app/theme/myTheme.dart'; // Import Firestore

class AllStudent extends StatefulWidget {
  const AllStudent({Key? key});

  @override
  State<AllStudent> createState() => _AllStudentState();
}

class _AllStudentState extends State<AllStudent> {
  int studentCount = 0;
  bool isLoading = true;
  int currentPage = 1;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    loadCollectionLength();
  }

  Future<void> loadCollectionLength() async {
    try {
      final res = await FirebaseFirestore.instance.collection("students").get();
      setState(() {
        studentCount = res.size;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading collection length: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "All Student",
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "Total Student: $studentCount",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "FontMain",
                      ),
                    ),
                  ),
                ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('students').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                // Paginate the documents
                final paginatedDocuments = documents
                    .skip((currentPage - 1) * itemsPerPage)
                    .take(itemsPerPage)
                    .toList();

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: paginatedDocuments.length,
                        itemBuilder: (BuildContext context, int index) {
                          final student = paginatedDocuments[index].data()
                              as Map<String, dynamic>;
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
                      _buildPaginator(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginator() {
    final totalPages = (studentCount / itemsPerPage).ceil();
    final visiblePages = 5; // Number of visible page buttons
    final startPage = currentPage - (visiblePages ~/ 2);
    final endPage = currentPage + (visiblePages ~/ 2);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: currentPage == 1 ? 0.0 : 1.0,
            duration: Duration(milliseconds: 300),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: currentPage > 1
                  ? () {
                      setState(() {
                        currentPage--;
                      });
                    }
                  : null,
            ),
          ),
          for (var i = startPage; i <= endPage; i++)
            if (i > 0 && i <= totalPages)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: _PageButton(
                  pageNumber: i,
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPressed: () {
                    setState(() {
                      currentPage = i;
                    });
                  },
                ),
              ),
          AnimatedOpacity(
            opacity: currentPage == totalPages ? 0.0 : 1.0,
            duration: Duration(milliseconds: 300),
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: currentPage < totalPages
                  ? () {
                      setState(() {
                        currentPage++;
                      });
                    }
                  : null,
            ),
          ),
        ],
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
    final isLastPage = pageNumber == totalPages;
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
        padding: EdgeInsets.all(8.0),
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

import 'package:flutter/material.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class AllStudent extends StatefulWidget {
  const AllStudent({Key? key});

  @override
  State<AllStudent> createState() => _AllStudentState();
}

class _AllStudentState extends State<AllStudent> {
  int studentCount = 0;
  bool isLoading = true;
  int currentPage = 1;
  int itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    loadCollectionLength();
  }

  Future<void> loadCollectionLength() async {
    try {
      FirebaseFirestore.instance.collection("students").count().get().then(
            (res) => {
              setState(() {
                studentCount = res.count ?? 0;
                isLoading = false;
              })
            },
            onError: (e) => print("Error completing: $e"),
          );
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "Total Student: $studentCount",
                      style: const TextStyle(
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
                  return const Center();
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                print(documents);

                // Paginate the documents
                final paginatedDocuments = documents
                    .skip((currentPage - 1) * itemsPerPage)
                    .take(itemsPerPage)
                    .toList();

                print("Hellllo pagin${paginatedDocuments}");

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                      const SizedBox(
                        height: 50,
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
    print("total pagesss${totalPages}");
    final visiblePages = 4; // Maximum number of visible page buttons
    final startPage = (currentPage - (visiblePages ~/ 2))
        .clamp(1, totalPages - visiblePages + 1);
    final endPage = (startPage + visiblePages - 1).clamp(1, totalPages);

    List<Widget> pageButtons = [];

    if (startPage > 2) {
      pageButtons.add(_PageButton(
        pageNumber: 1,
        currentPage: currentPage,
        totalPages: totalPages,
        onPressed: () {
          setState(() {
            currentPage = 1;
          });
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
      print(
          'startPage: $startPage, endPage: $endPage, totalPages: $totalPages');
      if (i > 0 && i <= totalPages) {
        pageButtons.add(
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
        );
      }
    }

    if (endPage < totalPages - 1) {
      pageButtons.add(const Text(
        '...',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    if (endPage < totalPages) {
      pageButtons.add(_PageButton(
        pageNumber: totalPages,
        currentPage: currentPage,
        totalPages: totalPages,
        onPressed: () {
          setState(() {
            currentPage = totalPages;
          });
        },
      ));
    }

    // Arrow buttons for previous and next page
    pageButtons.insert(
      0,
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: currentPage > 1
            ? () {
                setState(() {
                  currentPage--;
                });
              }
            : null,
      ),
    );

    pageButtons.add(
      IconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: currentPage < totalPages
            ? () {
                setState(() {
                  currentPage++;
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
    final isLastPage = pageNumber == totalPages;

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
        padding: EdgeInsets.all(paddingSize), // Use responsive padding
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

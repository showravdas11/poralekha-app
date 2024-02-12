import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({Key? key}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _pdfStream;

  @override
  void initState() {
    super.initState();
    _pdfStream = FirebaseFirestore.instance
        .collection("subjects")
        .doc(
            "adqxripumg9O6ZsUHjTL") // Replace with the actual document ID for the chapter
        .collection(
            "chapters") // Change to the name of your "subjects" collection
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("PDF Viewer"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _pdfStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<String> pdfLinks = snapshot.data!.docs
              .map((doc) => doc['pdfLink'] as String)
              .toList();

          return SfPdfViewer.network(
            pdfLinks[0],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("PDF Viewer"),
      ),
      body: SfPdfViewer.network(
          "https://firebasestorage.googleapis.com/v0/b/poralekha-b0a61.appspot.com/o/Book%20PDF%2FBuild%2010%20Flutter%203.0%20Apps%20in%20100%20Days%20%20A%20Step%20by%20Step%20Guide%20to%20build%20Apps%20and%20Master%20Flutter%20(Sanjib%20S%5B1%5D.pdf?alt=media&token=d67e9dd1-6eac-4ddb-9417-fbb6c33b1077"),
    );
  }
}

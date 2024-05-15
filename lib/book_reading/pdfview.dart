import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../Books_manage/book_page.dart';

class PdfViewer extends StatefulWidget {

  dynamic bookInfo;

  PdfViewer({required this.bookInfo});

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late FirebaseFirestore _firestore;
  bool isPageMarked = false;
  int currentPageNumber = 1;
  String? currentPdfPath;
  Color viewColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    fetchMarkedPages();
  }


  void fetchMarkedPages() async {
    // Fetch marked pages from Firestore
    final querySnapshot = await _firestore.collection('markedPages').get();
    final markedPages = querySnapshot.docs.map((doc) => doc['page']).toList();

    setState(() {
      isPageMarked = markedPages.contains(currentPageNumber);
    });
  }

  void toggleMark() async {
    // Toggle marking of current page
    setState(() {
      isPageMarked = !isPageMarked;
    });

    // Update marked pages in Firestore
    if (isPageMarked) {
      await _firestore.collection('markedPages').add({'page': currentPageNumber});
    } else {
      final querySnapshot = await _firestore
          .collection('markedPages')
          .where('page', isEqualTo: currentPageNumber)
          .get();
      final markedPageDocId = querySnapshot.docs.first.id;
      await _firestore.collection('markedPages').doc(markedPageDocId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookInfo['name'],
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
           // border: Border.all(width: 2, color: Colors.red),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 2.0,
                blurRadius: 8.0
              )
            ]
          ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

            child: SfPdfViewer.network(
                widget.bookInfo['url']),
        ),
      ),
    );
  }
}

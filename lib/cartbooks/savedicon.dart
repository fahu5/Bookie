import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedBookIcon extends StatefulWidget {
  SavedBookIcon({
    super.key,
    required this.dark,
    required this.bookInfo,
  });

  final bool dark;
  final dynamic bookInfo;

  @override
  _SavedBookIconState createState() => _SavedBookIconState();
}

class _SavedBookIconState extends State<SavedBookIcon> {
  bool isSaved = false; // State variable to track saved status

  // Method to save or remove book from Firestore
  Future<void> _saveBookToFirestore() async {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Reference to Firestore collection 'users'
      CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
      // Reference to the subcollection 'savedBooks' within the user's document
      CollectionReference savedBooksCollection =
      userCollection.doc(user.uid).collection('savedBooks');

      // Check if the book is already saved
      QuerySnapshot savedBooksQuery = await savedBooksCollection
          .where('bookTitle', isEqualTo: widget.bookInfo['name'])
          .get();

      if (savedBooksQuery.docs.isNotEmpty) {
        // Book is already saved, so remove it
        savedBooksQuery.docs.forEach((doc) async {
          await doc.reference.delete();
        });
      } else {
        // Book is not saved, so add it
        await savedBooksCollection.add({
          'bookTitle': widget.bookInfo['name'],
          'authorName': widget.bookInfo['author'],
          'imagepath': widget.bookInfo['book image'],
         // 'pdfpath': widget.bookInfo['url'],
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: widget.dark
              ? Colors.black.withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
        ),
        child: IconButton(
          onPressed: () async {
            setState(() {
              isSaved = !isSaved;
            });
            if (isSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Saved'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
            await _saveBookToFirestore();
          },
          icon: isSaved
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_add_outlined),
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }
}

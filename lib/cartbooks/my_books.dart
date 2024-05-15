import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../book_reading/pdfview.dart';

class Bookstore extends StatefulWidget {
  dynamic bookData;
   Bookstore({super.key});

  @override
  _BookstoreState createState() => _BookstoreState();
}

class _BookstoreState extends State<Bookstore> {
  late final CollectionReference userCollection;
  late final CollectionReference savedBooksCollection;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    userCollection = FirebaseFirestore.instance.collection('users');
    savedBooksCollection = userCollection.doc(user?.uid).collection('savedBooks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Books",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: savedBooksCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No books available'));
          } else {
            final documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                dynamic bookData = documents[index].data(); // Extract book data from DocumentSnapshot
                return ListTile(
                  leading: Image.network(bookData?['imagepath'] ?? ''),
                  title: Text(bookData?['bookTitle'] ?? ''),
                  subtitle: Text(bookData?['authorName'] ?? ''),
                  onTap: () {
                    // Ensure bookData is not null and contains the pdfpath field
                    if (bookData != null && bookData.containsKey('pdfpath')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfViewer(
                            bookInfo: {
                              'name': bookData['bookTitle'], // Pass book title as name
                              'url': bookData['pdfpath'],    // Pass pdf path as url
                            },
                          ),
                        ),
                      );
                    } else {
                      // Handle the case where pdfpath is missing or bookData is null
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('PDF path is missing for this book.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('favbooks')
                              .doc(documents[index].id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Show loading indicator while fetching favorite status
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Show error message if there's an error fetching favorite status
                              return const Icon(Icons.favorite_border, color: Colors.red);
                            } else {
                              // Determine the favorite status based on snapshot data
                              bool isFavorite = snapshot.data?.exists ?? false;
                              return Icon(
                                // Use filled heart icon if it's a favorite, otherwise use empty heart icon
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              );
                            }
                          },
                        ),
                        onPressed: () async {
                          // Toggle favorite status
                          DocumentReference favBookRef = FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('favbooks')
                              .doc(documents[index].id);

                          try {
                            // Check if the book is already in favorites
                            DocumentSnapshot favBookSnapshot = await favBookRef.get();
                            bool isFavorite = favBookSnapshot.exists;

                            // Toggle favorite status
                            if (isFavorite) {
                              // Remove from favorites
                              await favBookRef.delete();
                            } else {
                              // Add to favorites
                              await favBookRef.set({
                                'bookTitle': bookData['bookTitle'],
                                'authorName': bookData['authorName'],
                                // Add other necessary fields from bookData
                              });
                            }
                          } catch (e) {
                            print('Error toggling favorite status: $e');
                          }
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          // Show an AlertDialog to confirm deletion
                          bool confirmDelete = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Book'),
                              content: const Text('Are you sure you want to delete this book?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Return false to indicate cancellation of deletion
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Return true to indicate confirmation of deletion
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );

                          // If user confirmed deletion, proceed with deletion
                          if (confirmDelete == true) {
                            // Delete from savedBooks collection
                            await savedBooksCollection.doc(documents[index].id).delete();

                            // Delete from favbooks collection if it exists
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('favbooks')
                                .doc(documents[index].id)
                                .delete();
                          }
                        },
                      ),

                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

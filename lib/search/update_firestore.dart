import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateCollections() async {
  // Initialize Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List of collection names to update
  List<String> collectionsToUpdate = ['pdfs', 'novel', 'fiction', 'non-fiction', 'Romance', 'crimefiction', 'thrillers', 'poetry'];

  // Iterate over each collection
  for (String collectionName in collectionsToUpdate) {
    // Reference to the collection containing documents
    CollectionReference collectionReference = firestore.collection(collectionName);

    // Query all documents in the collection
    QuerySnapshot querySnapshot = await collectionReference.get();

    // Iterate through each document
    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      // Get the original name and author from the document
      String originalName = docSnapshot['name'];
      String originalAuthor = docSnapshot['author'];

      // Convert the name and author to lowercase
      String nameLowerCase = originalName.toLowerCase();
      String authorLowerCase = originalAuthor.toLowerCase();

      // Update the document with the lowercase fields
      await collectionReference.doc(docSnapshot.id).update({
        'name_lowercase': nameLowerCase,
        'author_lowercase': authorLowerCase,
      });

      print('Document updated: ${docSnapshot.id}');
    }

    print('All documents updated for collection: $collectionName');
  }

  print('All collections updated.');
}

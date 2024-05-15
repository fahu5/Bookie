
import 'package:bookiee/search/update_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../book_reading/pdfview.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    updateCollections(); // Call the function to update Firestore

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getSearchResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data?.isEmpty ?? true) {
            return const Center(child: Text('No search results found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> result = snapshot.data![index];
                return _buildResultTile(context, result);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildResultTile(BuildContext context, Map<String, dynamic> result) {
    return GestureDetector(
      onTap: () {
        _navigateToPdfViewer(context, result);
      },
      child: ListTile(
        leading: _buildLeading(result),
        title: Text(result['name'] ?? 'Unknown Title'),
        subtitle: Text(result['author'] ?? 'Unknown Author'),
      ),
    );
  }

  Widget _buildLeading(Map<String, dynamic> result) {
    if (result['book image'] != null && result['book image'] is String) {
      return Image.network(
        result['book image'],
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      return const SizedBox(width: 50, height: 50);
    }
  }

  void _navigateToPdfViewer(BuildContext context, Map<String, dynamic> result) {
    if (result['name'] != null && result['author'] != null &&
        result['url'] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewer(bookInfo: result),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book information is incomplete')),
      );
    }
  }


  Future<List<Map<String, dynamic>>> _getSearchResults() async {
    List<Map<String, dynamic>> results = [];

    String queryLowerCase = query.toLowerCase();

    // Perform query for each collection
    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection('pdfs')
        .where('name_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('name_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in querySnapshot1.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot authorquerySnapshot1 = await FirebaseFirestore.instance
        .collection('pdfs')
        .where('author_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('author_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in authorquerySnapshot1.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }


    QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('novel')
        .where('name_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('name_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in querySnapshot2.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot authorquerySnapshot2 = await FirebaseFirestore.instance
        .collection('novel')
        .where('author_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('author_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in authorquerySnapshot2.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot querySnapshot3 = await FirebaseFirestore.instance
        .collection('fiction')
        .where('name_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('name_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in querySnapshot3.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot authorquerySnapshot3 = await FirebaseFirestore.instance
        .collection('fiction')
        .where('author_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('author_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in authorquerySnapshot3.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot querySnapshot4 = await FirebaseFirestore.instance
        .collection('non-fiction')
        .where('name_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('name_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in querySnapshot4.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot authorquerySnapshot4 = await FirebaseFirestore.instance
        .collection('non-fiction')
        .where('author_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('author_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in authorquerySnapshot4.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot querySnapshot5 = await FirebaseFirestore.instance
        .collection('Romance')
        .where('name_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('name_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in querySnapshot5.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot authorquerySnapshot5 = await FirebaseFirestore.instance
        .collection('Romance')
        .where('author_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('author_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in authorquerySnapshot5.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot querySnapshot6 = await FirebaseFirestore.instance
        .collection('crimefiction')
        .where('name_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('name_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in querySnapshot6.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot authorquerySnapshot6 = await FirebaseFirestore.instance
        .collection('crimefiction')
        .where('author_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('author_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in authorquerySnapshot6.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot querySnapshot7 = await FirebaseFirestore.instance
        .collection('thrillers')
        .where('name_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('name_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in querySnapshot7.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot authorquerySnapshot7 = await FirebaseFirestore.instance
        .collection('thrillers')
        .where('author_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('author_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in authorquerySnapshot7.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot querySnapshot8 = await FirebaseFirestore.instance
        .collection('poetry')
        .where('name_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('name_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in querySnapshot8.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    QuerySnapshot authorquerySnapshot8 = await FirebaseFirestore.instance
        .collection('poetry')
        .where('author_lowercase', isGreaterThanOrEqualTo: queryLowerCase)
        .where('author_lowercase', isLessThan: '${queryLowerCase}z')
        .get();
    for (var doc in authorquerySnapshot8.docs) {
      results.add({
        'name': doc['name'],
        'author': doc['author'],
        'book image': doc['book image'],
        'url': doc['url'],
      });
    }

    // Add more queries for additional collections as needed

    return results;
  }
}


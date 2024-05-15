import 'package:bookiee/Core/Helper/helpfunction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Books_manage/booksgrid_layoutformat.dart';
import '../custom_homesc/primary_headercontainer.dart';
import '../custom_homesc/section_header.dart';
import '../search/result.dart';
import '../search/searchbar.dart';
import '../widget/header_title.dart';
import 'CategoryCall.dart';
import 'GridView_Books.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose(); // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(query: query),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a search term to begin searching")),
      );
    }
  }

  final Stream<QuerySnapshot> _stream =
  FirebaseFirestore.instance.collection('pdfs').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.deepPurpleAccent,
              automaticallyImplyLeading: false,
              title: const HeaderTitle(),
              pinned: true,
              expandedHeight: DeviceUtils.getAppBarHeight(),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              PrimaryHeaderContainer(
                child: Column(
                  children: [
                    SizedBox(height: 5.0),
                    Searchbox(
                      controller: _searchController,
                      onSearch: _handleSearch,
                    ),
                    SizedBox(height: 16.0),
                    CategoryCall(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0), // Ensure consistent padding
                child: Column(
                  children: [
                    const SectionHeader(title: 'Discover Books'),
                    const SizedBox(height: 10.0), // Adjust spacing
                    StreamBuilder<QuerySnapshot>(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.data?.docs.isEmpty ?? true) {
                          return const Text('No data available');
                        } else {
                          return BooksGridLayout(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = snapshot.data!.docs[index];
                              return BooksGrid(
                                bookInfo: document.data() as Map<String, dynamic>,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



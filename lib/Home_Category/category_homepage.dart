import 'package:bookiee/Core/Helper/helpfunction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Books_manage/RoundedImage.dart';
import '../Books_manage/booksgrid_layoutformat.dart';
import '../Homepage/GridView_Books.dart';
import '../custom_homesc/section_header.dart';



class CategoryHomepage extends StatefulWidget {
  const CategoryHomepage({super.key});

  @override
  State<CategoryHomepage> createState() => _CategoryHomepageState();
}

class _CategoryHomepageState extends State<CategoryHomepage> {

  final stream =
  FirebaseFirestore.instance.collection('novel').snapshots();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.deepPurpleAccent,
              automaticallyImplyLeading: false,
              title: const Text('Novel',
              style: TextStyle(
                  color: Colors.white
              )
              ),
              centerTitle: true,
              pinned: true,
              expandedHeight: DeviceUtils.getAppBarHeight(),
            ),
          ];
        },
       body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const RoundedImage(imageUrl: 'assets/novel_banner.jpg',),
                const Divider(),
                const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(HSizes.defaultspace),
                child: Column(
                  children: [
                    const SectionHeader(title: 'Novel',),
                    const SizedBox(height: 4.0),
                    StreamBuilder(
                      stream: stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text('No data available');
                        } else {
                          final List<DocumentSnapshot> documents = snapshot.data!.docs;
                          return BooksGridLayout(
                            itemCount: documents.length,
                            itemBuilder: (context, index) => BooksGrid(
                              bookInfo: documents[index],
                            ),
                          );

                        }
                      },
                    )

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

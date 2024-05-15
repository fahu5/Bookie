import 'package:bookiee/Core/Helper/helpfunction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Books_manage/RoundedImage.dart';
import '../Books_manage/booksgrid_layoutformat.dart';
import '../Homepage/GridView_Books.dart';




class Thrillers extends StatefulWidget {
  const Thrillers ({super.key});

  @override
  State<Thrillers > createState() => _ThrillersState();
}

class _ThrillersState extends State<Thrillers > {

  final stream =
  FirebaseFirestore.instance.collection('thrillers').snapshots();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.deepPurpleAccent,
              automaticallyImplyLeading: false,
              title: const Text('Thrillers ',
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
              const RoundedImage(imageUrl: 'assets/category/thrillers.jpg',),
              const Divider(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(HSizes.defaultspace),
                child: Column(
                  children: [
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/header_title.dart';
import 'bookmark.dart';

class MyBook extends StatelessWidget {
  const MyBook({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteBookList(),
      child: const Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderTitle(),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

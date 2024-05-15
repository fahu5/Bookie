import 'package:flutter/material.dart';

import '../Core/Helper/helpfunction.dart';
import 'category_icon.dart';

class CategoriesList extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final dynamic Function(int)? onTap;
  const CategoriesList({
    super.key,
    required this.categories,required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: HSizes.defaultspace),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length, // Use length of categories list
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final category = categories[index];
                return CategoryIcon(
                  key: Key(category['title']),
                  image: category['image'],
                  title: category['title'],
                  textColor: category['textColor'],
                  onTap: () => onTap!(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

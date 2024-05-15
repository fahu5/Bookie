import 'package:flutter/material.dart';
import '../Core/Helper/helpfunction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class BooksGridLayout extends StatefulWidget {
  const BooksGridLayout({
    super.key,
    required this.itemCount,
    this.mainAxisExtent=288,
    required this.itemBuilder,
  });

  final int itemCount;
  final double? mainAxisExtent;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  State<BooksGridLayout> createState() => _BooksGridLayoutState();
}

class _BooksGridLayoutState extends State<BooksGridLayout> {

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.itemCount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Adjust number of columns
        mainAxisExtent: widget.mainAxisExtent,
        mainAxisSpacing: HSizes.gridViewSpacing, // Spacing between items
        crossAxisSpacing: HSizes.gridViewSpacing, // Spacing between items
      ),
      itemBuilder: widget.itemBuilder,
    );
  }
}

import 'package:flutter/material.dart';

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount, // Use the itemCount provided in the constructor
      itemBuilder: (context, index) {
        return itemBuilder(context, index); // Use itemBuilder to build each item
      },
    );
  }
}

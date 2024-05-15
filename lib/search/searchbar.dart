import 'package:flutter/material.dart';
import '../Core/Helper/helpfunction.dart';


class Searchbox extends StatelessWidget {
  final TextEditingController controller;  // Controller to manage text input
  final Function(String) onSearch;         // Callback function to handle search

  const Searchbox({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        width: DeviceUtils.getScreenWidth(context),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(35.0),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.white70),
            const SizedBox(width: 3.0),
            Expanded(
              child: TextField(
                controller: controller,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                decoration: InputDecoration(
                  hintText: "Search Title/Author",
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onSubmitted: onSearch,  // Trigger search callback when the user submits their search
              ),
            ),
          ],
        ),
      ),
    );
  }
}



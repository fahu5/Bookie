import 'package:flutter/material.dart';

class ReadingProgress extends StatelessWidget {
  final double progress; // Percentage (0.0 to 1.0)
  final int completedBooks;
  final int totalBooks;


  const ReadingProgress({
    super.key,
    required this.progress,
    required this.completedBooks,
    required this.totalBooks,

  });

  @override
  Widget build(BuildContext context) {
    final completedSegments = (progress * 100).round();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.schedule, color: Colors.green),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: progress,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                backgroundColor: Colors.grey[300],
              ),

              // Text showing progress and book count
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "$completedSegments% ($completedBooks of $totalBooks)",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}

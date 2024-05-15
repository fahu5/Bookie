import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../book_reading/pdfview.dart';
import '../cartbooks/savedicon.dart';
import 'RoundedImage.dart';

class BookService {
  static Future<void> saveBook(OpenBookDetailsData bookDetails) async {
    print('Saving book: ${bookDetails.title} by ${bookDetails.author}');
  }
}

class OpenBookDetailsData {
  final String title;
  final String author;
  final double rating;
  final String assetPath;
  final String description;
  final String url; // Added URL field

  OpenBookDetailsData({
    required this.assetPath,
    required this.title,
    required this.author,
    required this.rating,
    required this.description,
    required this.url, // Updated constructor
  });
}

class BookPage extends StatefulWidget {
  final dynamic bookInfo;

  BookPage({required this.bookInfo});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookInfo['name']),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ShareDialog(bookInfo: widget.bookInfo),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 150,
                child: Image.network(widget.bookInfo['book image']),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bookInfo['name'],
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          widget.bookInfo['author'],
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            buildRatingWidget(widget.bookInfo['rating']),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(thickness: 3.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.bookInfo['description'],
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 16.0,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewer(
                        bookInfo: widget.bookInfo,
                      ),
                    ),
                  );
                },
                child: const Text('Continue Reading'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRatingWidget(String ratingString) {
    double rating = double.tryParse(ratingString) ?? 0.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 5; i++)
          Icon(
            Icons.star,
            color: i < rating ? Colors.amber : Colors.grey,
            size: 16,
          ),
      ],
    );
  }
}

class ShareDialog extends StatelessWidget {
  final dynamic bookInfo;

  const ShareDialog({Key? key, required this.bookInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Share Book'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Share this book with your friends.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            _shareBook(context);
          },
          child: const Text('Share'),
        ),
      ],
    );
  }

  void _shareBook(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final String text = 'Check out this book: ${bookInfo['name']} by ${bookInfo['author']}. ${bookInfo['url']}'; // Modified text to include URL
    Share.share(text, subject: 'Book Recommendation', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}




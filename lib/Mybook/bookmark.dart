import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String title;
  final String author;

  const Book({required this.title, this.author = ''});

  Map<String, dynamic> toJson() => {'title': title, 'author': author};

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    title: json['title'] as String,
    author: json['author'] as String,
  );
}

class SavedBook extends Book {
  SavedBook({required super.title, super.author});

  factory SavedBook.fromJson(Map<String, dynamic> json) => SavedBook(
    title: json['title'] as String,
    author: json['author'] as String,
  );
}

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _booksCollection = 'books';

  Future<void> addBook(SavedBook book) async {
    await _firestore.collection(_booksCollection).add(book.toJson());
  }

  Stream<List<SavedBook>> getBooks() {
    return _firestore.collection(_booksCollection).snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => SavedBook.fromJson(doc.data()))
          .toList(),
    );
  }
}

class FavoriteBookList extends ChangeNotifier {
  List<SavedBook> favoriteBooks = [];

  void addToFavorites(SavedBook book, String selectedList) {
    favoriteBooks.add(book);
    notifyListeners();
  }

  void removeFromFavorites(SavedBook book) {
    favoriteBooks.remove(book);
    notifyListeners();
  }
}

class BookListScreen extends StatefulWidget {
  final FavoriteBookList favoriteBookList;

  const BookListScreen({super.key, required this.favoriteBookList});

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookService _bookService = BookService();
  late Stream<List<SavedBook>> _booksStream;

  @override
  void initState() {
    super.initState();
    _booksStream = _bookService.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddBookScreen(),
                        ),
                      ),
                      child: const Text('Add Book'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoriteBooksScreen(
                            favoriteBookList: widget.favoriteBookList,
                          ),
                        ),
                      ),
                      child: const Text('Favorite Books'),
                    ),
                  ],
                ),
              ),
              StreamBuilder<List<SavedBook>>(
                stream: _booksStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final books = snapshot.data ?? [];
                  return books.isEmpty
                      ? const Text('No Saved Books Found')
                      : Column(
                    children: books.map((book) => buildBookTile(context, book)).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBookTile(BuildContext context, SavedBook book) {
    return ListTile(
      title: Text(book.title),
      subtitle: Text(book.author),
    );
  }
}

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Author (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final book = SavedBook(
                      title: _titleController.text,
                      author: _authorController.text,
                    );
                    _saveBook(book);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBook(SavedBook book) async {
    try {
      await BookService().addBook(book);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book added successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving book: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class FavoriteBooksScreen extends StatelessWidget {
  final FavoriteBookList favoriteBookList;

  const FavoriteBooksScreen({super.key, required this.favoriteBookList});

  @override
  Widget build(BuildContext context) {
    // Your implementation for the FavoriteBooksScreen UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Books'),
      ),
      body: // Your implementation here,
      const Center(
        child: Text('Favorite Books Screen'),
      ),
    );
  }
}

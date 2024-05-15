import 'package:flutter/material.dart';
import '../Books_manage/book_page.dart';
import '../Books_manage/books_title.dart';
import '../Core/Helper/helpfunction.dart';
import '../cartbooks/savedicon.dart';


class BooksGrid extends StatefulWidget {
   BooksGrid({
    super.key,
     // required this.bookData,
    this.onTap,
     // required this.detailsList,
    required this.bookInfo,
  });

  dynamic bookInfo;
   // final BookData bookData;
  final VoidCallback? onTap;
   // final List<OpenBookDetailsData> detailsList;

  @override
  _BooksGridState createState() => _BooksGridState();
}

class _BooksGridState extends State<BooksGrid> {
  late String selectedList;
  @override
  void initState() {
    super.initState();
    selectedList = 'List 1'; // Set the default value
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BookPage(
                  bookInfo: widget.bookInfo,
                ),
          ),
        );
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: dark ? HColors.Dark : HColors.light,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(widget.bookInfo['book image'],fit: BoxFit.cover,height: 180,),

                ),
                const SizedBox(height: 0.5),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BooksTitle(
                            title: widget.bookInfo['name'], smallSize: true),
                        const SizedBox(height: 3),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bookInfo['author'],
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(width: HSizes.xs),
                        Row(
                          children: [
                            buildRatingWidget(widget.bookInfo['rating']),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SavedBookIcon(
              dark: dark,
              bookInfo:  {
                'name': widget.bookInfo['name'],
                'author':  widget.bookInfo['author'],
                'book image': widget.bookInfo['book image'],
                 //'url': widget.bookInfo['url'],
              },
            )

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








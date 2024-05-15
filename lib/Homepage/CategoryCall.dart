import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Home_Category/category_list.dart';
import '../Home_Category/crime-fiction.dart';
import '../Home_Category/fiction.dart';
import '../Home_Category/non_fiction.dart';
import '../Home_Category/novel.dart';
import '../Home_Category/poetry.dart';
import '../Home_Category/romance.dart';
import '../Home_Category/thrillers.dart';

class CategoryCall extends StatelessWidget {
  const CategoryCall({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CategoriesList(
      categories: const [
        //{'image': 'assets/icon/audiobook_icon.png', 'title': '  Audio Books', 'textColor': Colors.white,},
        {'image': 'assets/icon/novelbook_icon.png', 'title': 'Novel', 'textColor': Colors.white},
        {'image': 'assets/icon/fiction_icon.png', 'title': 'Fiction', 'textColor': Colors.white},
        {'image': 'assets/icon/Non-fictionbook_icon.png', 'title': '   Non-Fiction', 'textColor': Colors.white},
        {'image': 'assets/icon/poetry_icon.png', 'title': 'Poetry', 'textColor': Colors.white},
        {'image': 'assets/icon/romancebook_icon.png', 'title': 'Romance', 'textColor': Colors.white},
        {'image': 'assets/icon/thrillerbook_icon.png', 'title': 'Thrillers', 'textColor': Colors.white},
        {'image': 'assets/icon/crimefiction_book_icon.png', 'title': '  Crime Fiction', 'textColor': Colors.white},

      ],
      onTap: (int index) {
        if (index == 0) {
          // Handle tap on first category novel
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Novel(),
            ),
          );
        }
        if (index == 1) {
          // Handle tap on 2nd category  fiction
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Fiction(),
            ),
          );
        }
        if (index == 2) {
          // Handle tap on 3rd category nonfiction
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NonFiction(),
            ),
          );
        }
        if (index == 3) {
          // Handle tap on 4th category poetry
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Poetry(),
            ),
          );
        }
        if (index == 4) {
          // Handle tap on 4th category
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Romance(),
            ),
          );
        }
        if (index == 5) {
          // Handle tap on 4th category
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Thrillers(),
            ),
          );
        }
        if (index == 6) {
          // Handle tap on 4th category
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CrimeFiction(),
            ),
          );
        }




      },
    );
  }
}

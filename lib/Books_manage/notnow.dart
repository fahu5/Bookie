import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../Core/Helper/helpfunction.dart';
import '../Homepage/circularcontainer.dart';
import 'discovering_books.dart';

class discoveringslide extends StatelessWidget {
  const discoveringslide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(HSizes.defaultspace),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(

              ),
              items: const [
                DiscoveringBooks(imageUrl: 'assets/category/novel_banner.jpg',),
                DiscoveringBooks(imageUrl: 'assets/category/novel_banner.jpg',),
                DiscoveringBooks(imageUrl: 'assets/category/novel_banner.jpg',),


              ],
            ),
            const SizedBox(height: HSizes.spacebtwitems,),
            const CircularContainer(
              width:20,
              height:20,
              backgroundColor: Colors.deepPurple,
            )
          ],
        )//
    );
  }
}

import 'package:flutter/material.dart';
import '../Core/Helper/helpfunction.dart';
import '../Homepage/notification_storage.dart';
import 'header.dart';
import 'notification.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderAppbar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            HText.homeAppBarTitle,
            style: Theme.of(context).textTheme.headlineMedium?.apply(color: Colors.white),
          ),
          Text(
            HText.homeAppBarSubTitle,
            style: Theme.of(context).textTheme.labelMedium?.apply(color: Colors.white),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.white,),
          onPressed: () {
            Navigator.pushNamed(context, '/notifications'); // Navigate to the notifications page
          },
        ),
      ],
    );
  }
}

//actions:  [ProfileBar(onPressed: (){}, iconColor: Colors.white)],

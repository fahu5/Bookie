import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'Theme/ThemeNotifier.dart'; // Make sure to import the ThemeNotifier if it's in a different file

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: const BackButton(color: Colors.white),
    backgroundColor: Colors.deepPurple,
    elevation: 4, // Adding some elevation for better visibility
    title: const Text(
      'Profile',
      style: TextStyle(color: Colors.white),
    ),
    centerTitle: true,
    actions: <Widget>[
      Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) => Switch(
          value: themeNotifier.isDarkMode,
          onChanged: (value) {
            themeNotifier.toggleTheme();
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
      ),
    ],
  );
}

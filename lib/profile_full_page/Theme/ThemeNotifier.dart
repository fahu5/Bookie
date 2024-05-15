import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  bool _isDarkMode = false;  // Initial theme state

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

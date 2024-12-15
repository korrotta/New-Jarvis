import 'package:flutter/material.dart';
import 'package:newjarvis/themes/light_theme.dart';
import 'package:newjarvis/themes/dark_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme = lightTheme;

  ThemeData get getTheme => _selectedTheme;

  bool get isDarkTheme => _selectedTheme == darkTheme;

  void setTheme(ThemeData theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  void toggleTheme() {
    _selectedTheme = _selectedTheme == darkTheme ? lightTheme : darkTheme;
    notifyListeners();
  }
}

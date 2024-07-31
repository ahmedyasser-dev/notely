import 'package:flutter/material.dart';
import 'package:notely2/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  // initially, theme is light mode
  ThemeData _themeData = lightMode;

  ThemeProvider() {
    loadThemeData();
  }

  // getter method to access the theme from other parts of the code
  ThemeData get themeData => _themeData;

  // getter method to see if we darkMode or not
  bool get isDarkMode => _themeData == darkMode;

  // setter method to set a new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    saveThemeData();
    notifyListeners();
  }

  // toggle theme from light to dark and reverse
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  void loadThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? darkMode : lightMode;
    notifyListeners();
  }

  void saveThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }
}

import 'package:chat_app/themes/dart_mode.dart';
import 'package:chat_app/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  ThemeProvider({required this.sharedPreferences}) {
    _themeData =
        (sharedPreferences.getBool('isDark') ?? false) ? darkMode : lightMode;
  }

  late ThemeData _themeData;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = isDarkMode ? lightMode : darkMode;
    sharedPreferences.setBool('isDark', isDarkMode);
    notifyListeners();
  }
}

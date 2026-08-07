import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = "dark_mode";

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool(_themeKey) ?? false;

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_themeKey, value);
  }
}
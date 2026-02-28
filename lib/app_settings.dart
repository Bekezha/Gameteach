import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('ru');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  AppSettings() {
    _loadSettings();
  }

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  void changeLanguage(String langCode) async {
    _locale = Locale(langCode);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool('isDark') ?? false;
    final lang = prefs.getString('language') ?? 'ru';

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _locale = Locale(lang);

    notifyListeners();
  }
}

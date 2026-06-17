import 'package:flutter/material.dart';

enum ThemeModeOption { light, dark, auto }

class SettingsProvider extends ChangeNotifier {
  ThemeModeOption _themeMode = ThemeModeOption.light;
  String _language = 'English';
  bool _notificationsEnabled = true;

  ThemeModeOption get themeMode => _themeMode;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;

  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.auto:
        return ThemeMode.system;
    }
  }

  void setThemeMode(ThemeModeOption mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  void clearCache() {}
}

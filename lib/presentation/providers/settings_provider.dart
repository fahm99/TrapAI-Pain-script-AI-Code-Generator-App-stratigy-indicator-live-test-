import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';

enum ThemeModeOption { light, dark, auto }

class SettingsProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService.instance;

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

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    if (!_supabase.isAuthenticated) return;
    try {
      final data = await _supabase.getSettings();
      if (data != null) {
        _themeMode = ThemeModeOption.values.firstWhere(
          (e) => e.name == data['theme'],
          orElse: () => ThemeModeOption.light,
        );
        _notificationsEnabled = data['notifications_enabled'] ?? true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> setThemeMode(ThemeModeOption mode) async {
    _themeMode = mode;
    notifyListeners();
    try {
      await _supabase.updateSettings(theme: mode.name);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    notifyListeners();
    try {
      await _supabase.updateSettings(language: lang);
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
    try {
      await _supabase.updateSettings(notificationsEnabled: _notificationsEnabled);
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

  void clearCache() {}
}

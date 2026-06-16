import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  String _language = 'English (US)';
  String _currency = 'USD (\$)';
  String _chartProvider = 'TradingView Integrated';
  bool _compactView = false;
  bool _monospacedLabels = true;
  ThemeMode _themeMode = ThemeMode.light;

  String get language => _language;
  String get currency => _currency;
  String get chartProvider => _chartProvider;
  bool get compactView => _compactView;
  bool get monospacedLabels => _monospacedLabels;
  ThemeMode get themeMode => _themeMode;

  void setLanguage(String value) {
    _language = value;
    notifyListeners();
  }

  void setCurrency(String value) {
    _currency = value;
    notifyListeners();
  }

  void setChartProvider(String value) {
    _chartProvider = value;
    notifyListeners();
  }

  void toggleCompactView() {
    _compactView = !_compactView;
    notifyListeners();
  }

  void toggleMonospacedLabels() {
    _monospacedLabels = !_monospacedLabels;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

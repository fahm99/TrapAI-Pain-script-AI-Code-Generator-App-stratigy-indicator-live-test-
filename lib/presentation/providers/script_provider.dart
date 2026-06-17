import 'package:flutter/foundation.dart';

class ScriptProvider extends ChangeNotifier {
  String _generatedCode = '';
  String _selectedType = 'Indicator';
  String _selectedVersion = 'Pine Script v6';
  bool _isGenerating = false;

  String get generatedCode => _generatedCode;
  String get selectedType => _selectedType;
  String get selectedVersion => _selectedVersion;
  bool get isGenerating => _isGenerating;

  void setType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  void setVersion(String version) {
    _selectedVersion = version;
    notifyListeners();
  }

  Future<void> generateScript(String prompt) async {
    _isGenerating = true;
    _generatedCode = '';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    _generatedCode =
        '//@version=6\nindicator("AI Generated: $prompt", overlay=true)\n\nrsi = ta.rsi(close, 14)\nplot(rsi, "RSI", color=color.blue)\n';
    _isGenerating = false;
    notifyListeners();
  }
}

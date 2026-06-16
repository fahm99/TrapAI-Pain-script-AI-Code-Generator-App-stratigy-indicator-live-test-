import 'package:flutter/material.dart';
import '../../domain/entities/pine_script_entity.dart';
import '../../domain/repositories/script_repository.dart';

class ScriptProvider extends ChangeNotifier {
  final ScriptRepository _repository;

  ScriptProvider(this._repository);

  List<PineScriptEntity> _scripts = [];
  PineScriptEntity? _currentScript;
  bool _isLoading = false;
  String? _error;

  List<PineScriptEntity> get scripts => _scripts;
  PineScriptEntity? get currentScript => _currentScript;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadScripts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _scripts = await _repository.getScripts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectScript(PineScriptEntity script) {
    _currentScript = script;
    notifyListeners();
  }

  Future<void> generateScript(String prompt, String mode, String version) async {
    _isLoading = true;
    notifyListeners();

    try {
      final script = await _repository.generateScript(prompt, mode, version);
      _scripts.insert(0, script);
      _currentScript = script;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteScript(String id) async {
    await _repository.deleteScript(id);
    _scripts.removeWhere((s) => s.id == id);
    if (_currentScript?.id == id) {
      _currentScript = null;
    }
    notifyListeners();
  }
}

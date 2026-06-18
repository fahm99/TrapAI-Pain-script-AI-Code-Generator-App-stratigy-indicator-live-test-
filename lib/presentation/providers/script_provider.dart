import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/services/gemini_service.dart';
import '../../domain/entities/pine_script_entity.dart';

class ScriptProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService.instance;

  String _generatedCode = '';
  String _selectedType = 'Indicator';
  String _selectedVersion = 'Pine Script v6';
  bool _isGenerating = false;
  List<PineScriptEntity> _savedScripts = [];

  String get generatedCode => _generatedCode;
  String get selectedType => _selectedType;
  String get selectedVersion => _selectedVersion;
  bool get isGenerating => _isGenerating;
  List<PineScriptEntity> get savedScripts => _savedScripts;

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

    _generatedCode = await GeminiService.generatePineScript(
      prompt: prompt,
      type: _selectedType,
      version: _selectedVersion,
    );
    _isGenerating = false;
    notifyListeners();
  }

  Future<void> loadSavedScripts() async {
    if (!_supabase.isAuthenticated) return;
    try {
      final data = await _supabase.getPineScripts();
      _savedScripts = data.map((s) => PineScriptEntity(
        id: s['id'],
        filename: s['filename'],
        content: s['content'],
        version: s['version'],
        mode: s['script_type'],
        createdAt: DateTime.parse(s['created_at']),
      )).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading scripts: $e');
    }
  }

  Future<void> saveScript({String? sessionId}) async {
    if (_generatedCode.isEmpty) return;
    try {
      await _supabase.savePineScript(
        filename: 'script_${DateTime.now().millisecondsSinceEpoch}.pine',
        content: _generatedCode,
        version: _selectedVersion == 'Pine Script v6' ? 'v6' : 'v5',
        scriptType: _selectedType.toLowerCase(),
        sessionId: sessionId,
      );
      await loadSavedScripts();
    } catch (e) {
      debugPrint('Error saving script: $e');
    }
  }

  Future<void> deleteScript(String scriptId) async {
    try {
      await _supabase.deletePineScript(scriptId);
      _savedScripts.removeWhere((s) => s.id == scriptId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting script: $e');
    }
  }
}

import 'package:uuid/uuid.dart';
import '../../domain/entities/pine_script_entity.dart';
import '../../domain/repositories/script_repository.dart';
import '../datasources/mock_datasource.dart';

class ScriptRepositoryImpl implements ScriptRepository {
  final MockDataSource _dataSource;
  final List<PineScriptEntity> _cache = [];

  ScriptRepositoryImpl(this._dataSource);

  @override
  Future<List<PineScriptEntity>> getScripts() async {
    if (_cache.isEmpty) {
      _cache.addAll(await _dataSource.getScripts());
    }
    return _cache;
  }

  @override
  Future<PineScriptEntity?> getScript(String id) async {
    final scripts = await getScripts();
    try {
      return scripts.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveScript(PineScriptEntity script) async {
    final index = _cache.indexWhere((s) => s.id == script.id);
    if (index >= 0) {
      _cache[index] = script;
    } else {
      _cache.add(script);
    }
  }

  @override
  Future<void> deleteScript(String id) async {
    _cache.removeWhere((s) => s.id == id);
  }

  @override
  Future<PineScriptEntity> generateScript(String prompt, String mode, String version) async {
    final message = await _dataSource.sendMessage(prompt);
    final script = PineScriptEntity(
      id: const Uuid().v4(),
      filename: '${prompt.toLowerCase().replaceAll(' ', '_')}.pine',
      version: version,
      content: message.codeBlock ?? '',
      mode: mode,
      createdAt: DateTime.now(),
    );
    await saveScript(script);
    return script;
  }
}

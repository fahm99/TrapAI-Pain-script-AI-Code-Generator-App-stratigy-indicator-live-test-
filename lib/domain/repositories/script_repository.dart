import '../entities/pine_script_entity.dart';

abstract class ScriptRepository {
  Future<List<PineScriptEntity>> getScripts();
  Future<PineScriptEntity?> getScript(String id);
  Future<void> saveScript(PineScriptEntity script);
  Future<void> deleteScript(String id);
  Future<PineScriptEntity> generateScript(String prompt, String mode, String version);
}

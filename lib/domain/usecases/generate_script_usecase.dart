import '../entities/pine_script_entity.dart';
import '../repositories/script_repository.dart';

class GenerateScriptUseCase {
  final ScriptRepository _repository;

  GenerateScriptUseCase(this._repository);

  Future<PineScriptEntity> call(String prompt, String mode, String version) {
    return _repository.generateScript(prompt, mode, version);
  }
}

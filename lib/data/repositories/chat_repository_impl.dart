import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_session_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/mock_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final MockDataSource _dataSource;

  ChatRepositoryImpl(this._dataSource);

  @override
  Future<ChatMessageEntity> sendMessage(String sessionId, String content, {String? imagePath}) {
    return _dataSource.sendMessage(content, imagePath: imagePath);
  }

  @override
  Future<List<ChatSessionEntity>> getChatSessions() {
    return _dataSource.getChatSessions();
  }

  @override
  Future<ChatSessionEntity?> getChatSession(String sessionId) async {
    final sessions = await _dataSource.getChatSessions();
    try {
      return sessions.firstWhere((s) => s.id == sessionId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteChatSession(String sessionId) async {}

  @override
  Future<ChatMessageEntity> generatePineScript(String prompt, String mode, String version) {
    return _dataSource.sendMessage(prompt);
  }
}

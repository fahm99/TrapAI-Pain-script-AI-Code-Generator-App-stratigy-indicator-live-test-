import '../entities/chat_message_entity.dart';
import '../entities/chat_session_entity.dart';

abstract class ChatRepository {
  Future<ChatMessageEntity> sendMessage(String sessionId, String content, {String? imagePath});
  Future<List<ChatSessionEntity>> getChatSessions();
  Future<ChatSessionEntity?> getChatSession(String sessionId);
  Future<void> deleteChatSession(String sessionId);
  Future<ChatMessageEntity> generatePineScript(String prompt, String mode, String version);
}

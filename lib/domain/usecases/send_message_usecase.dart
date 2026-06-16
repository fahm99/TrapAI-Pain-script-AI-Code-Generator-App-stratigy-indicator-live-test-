import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository _repository;

  SendMessageUseCase(this._repository);

  Future<ChatMessageEntity> call(String sessionId, String content, {String? imagePath}) {
    return _repository.sendMessage(sessionId, content, imagePath: imagePath);
  }
}

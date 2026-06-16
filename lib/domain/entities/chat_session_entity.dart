import 'chat_message_entity.dart';

class ChatSessionEntity {
  final String id;
  final String title;
  final List<ChatMessageEntity> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatSessionEntity({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  ChatSessionEntity copyWith({
    String? title,
    List<ChatMessageEntity>? messages,
  }) {
    return ChatSessionEntity(
      id: id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

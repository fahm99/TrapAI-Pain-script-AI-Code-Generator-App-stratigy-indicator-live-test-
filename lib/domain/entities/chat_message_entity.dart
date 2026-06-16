enum MessageRole { user, assistant }

class ChatMessageEntity {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final String? codeBlock;
  final String? imagePath;
  final bool isTyping;

  const ChatMessageEntity({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.codeBlock,
    this.imagePath,
    this.isTyping = false,
  });

  ChatMessageEntity copyWith({
    String? content,
    String? codeBlock,
    bool? isTyping,
  }) {
    return ChatMessageEntity(
      id: id,
      content: content ?? this.content,
      role: role,
      timestamp: timestamp,
      codeBlock: codeBlock ?? this.codeBlock,
      imagePath: imagePath,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

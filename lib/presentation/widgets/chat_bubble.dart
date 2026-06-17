import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  bool get isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('AI', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 6),
                Text('TrapAI', style: AppTypography.labelSm),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primary : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: isUser ? null : Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.imagePath != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      message.imagePath!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                SelectableText(
                  message.content,
                  style: TextStyle(
                    color: isUser ? Colors.white : AppColors.textMain,
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: isUser ? null : 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class ChatInputBar extends StatelessWidget {
  final String hint;
  final Function(String)? onSend;
  final VoidCallback? onImagePressed;
  final bool showContextChips;

  const ChatInputBar({
    super.key,
    required this.hint,
    this.onSend,
    this.onImagePressed,
    this.showContextChips = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showContextChips) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.chipBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 12),
                      const SizedBox(width: 4),
                      Text('Indicator', style: AppTypography.labelSm.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.chipBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.code, size: 12),
                      const SizedBox(width: 4),
                      Text('v6', style: AppTypography.labelSm.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              if (onImagePressed != null)
                IconButton(
                  icon: const Icon(Icons.image_outlined, size: 22),
                  onPressed: onImagePressed,
                ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                  style: AppTypography.bodyMd,
                  onSubmitted: (text) {
                    if (text.isNotEmpty && onSend != null) {
                      onSend!(text);
                    }
                  },
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  // Trigger send
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_upward, color: AppColors.onPrimary, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

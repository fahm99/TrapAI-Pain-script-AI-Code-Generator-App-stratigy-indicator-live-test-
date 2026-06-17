import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/chat_provider.dart';
import '../../providers/script_provider.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/empty_state.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedType = 'Indicator';
  String _selectedVersion = 'Pine Script v6';
  String? _imagePath;

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _send() {
    final text = _promptController.text.trim();
    if (text.isEmpty && _imagePath == null) return;

    context.read<ChatProvider>().sendMessage(text, imagePath: _imagePath);
    _promptController.clear();
    setState(() => _imagePath = null);
    _scrollToBottom();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imagePath = picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<ChatProvider>(
            builder: (context, chat, _) {
              if (chat.messages.isEmpty) {
                return const EmptyState(
                  icon: Icons.chat_bubble_outline,
                  title: 'Start a conversation',
                  subtitle: 'Ask TrapAI to generate Pine Script code, indicators, or strategies.',
                );
              }
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                physics: const BouncingScrollPhysics(),
                itemCount: chat.messages.length + (chat.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == chat.messages.length) {
                    return const _TypingIndicator();
                  }
                  final msg = chat.messages[index];
                  return ChatBubble(message: msg);
                },
              );
            },
          ),
        ),
        _buildInputContainer(),
      ],
    );
  }

  Widget _buildInputContainer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    style: AppTypography.bodyMd.copyWith(color: AppColors.textMain),
                    decoration: InputDecoration(
                      hintText: 'Describe your Pine Script...',
                      hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image_outlined, size: 20, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
            if (_imagePath != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.image, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _imagePath!.split('/').last,
                        style: AppTypography.bodySm,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => setState(() => _imagePath = null),
                      child: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                _buildDropdown(
                  value: _selectedType,
                  items: const ['Indicator', 'Strategy'],
                  onChanged: (v) => setState(() => _selectedType = v!),
                ),
                const SizedBox(width: 8),
                _buildDropdown(
                  value: _selectedVersion,
                  items: const ['Pine Script v6', 'Pine Script v5'],
                  onChanged: (v) => setState(() => _selectedVersion = v!),
                ),
                const Spacer(),
                _buildSendButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          style: AppTypography.labelText.copyWith(color: AppColors.textMain),
          icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textMuted),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: _send,
        borderRadius: BorderRadius.circular(10),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.arrow_upward, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(0), const SizedBox(width: 4), _dot(1), const SizedBox(width: 4), _dot(2),
          ],
        ),
      ),
    );
  }

  Widget _dot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (_, v, __) {
        return Opacity(
          opacity: v.clamp(0.3, 1.0),
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.textMuted,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

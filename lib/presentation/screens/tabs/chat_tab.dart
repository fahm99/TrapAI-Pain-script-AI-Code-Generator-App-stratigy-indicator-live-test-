import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/chat_message_entity.dart';
import '../../providers/chat_provider.dart';
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

    context.read<ChatProvider>().sendMessage(
      text,
      imagePath: _imagePath,
      type: _selectedType,
      version: _selectedVersion,
    );
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
                  return _ChatBubble(message: msg);
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
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_imagePath != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.image, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _imagePath!.split('/').last,
                      style: AppTypography.bodySm,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _imagePath = null),
                    child: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          TextField(
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            ),
          ),
          Row(
            children: [
              _iconButton(Icons.image_outlined, _pickImage),
              const SizedBox(width: 4),
              _buildDropdown(
                value: _selectedType,
                items: const ['Indicator', 'Strategy'],
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
              const SizedBox(width: 6),
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
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: AppColors.textMuted),
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          style: TextStyle(fontSize: 12, color: AppColors.textMain),
          icon: const Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textMuted),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
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
          padding: EdgeInsets.all(8),
          child: Icon(Icons.arrow_upward, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final dynamic message;
  const _ChatBubble({required this.message});

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
              maxWidth: MediaQuery.of(context).size.width * 0.82,
            ),
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primary : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: isUser ? null : Border.all(color: AppColors.border, width: 0.5),
            ),
            child: isUser
                ? SelectableText(
                    message.content,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  )
                : _buildMarkdownResponse(message.content),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkdownResponse(String text) {
    final codeRegex = RegExp(r'```(\w*)\n([\s\S]*?)```', multiLine: true);
    final parts = <InlineSpan>[];
    int lastEnd = 0;

    for (final match in codeRegex.allMatches(text)) {
      if (match.start > lastEnd) {
        parts.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      final lang = match.group(1) ?? '';
      final code = match.group(2) ?? '';
      parts.add(WidgetSpan(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (lang.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(lang.toUpperCase(), style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
                SelectableText(code.trim(), style: const TextStyle(color: Color(0xFFD4D4D4), fontSize: 13, height: 1.5, fontFamily: 'monospace')),
            ],
          ),
        ),
      ));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      parts.add(TextSpan(text: text.substring(lastEnd)));
    }

    if (parts.isEmpty) {
      return SelectableText(text, style: const TextStyle(color: AppColors.textMain, fontSize: 14, height: 1.6));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: AppColors.textMain, fontSize: 14, height: 1.6),
        children: parts,
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
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(), SizedBox(width: 4), _Dot(), SizedBox(width: 4), _Dot(),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot();
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Opacity(
        opacity: _animation.value,
        child: Container(
          width: 7, height: 7,
          decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/trapai_app_bar.dart';
import '../../widgets/trapai_bottom_nav.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/chat_input_bar.dart';
import '../../widgets/code_block_widget.dart';
import '../../widgets/drawer_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TrapAIAppBar(
        onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
      ),
      endDrawer: const AppDrawer(),
      body: Column(
        children: [
          // Mode/Version selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Consumer<ChatProvider>(
              builder: (context, chat, _) {
                return Row(
                  children: [
                    _buildModeChip('Indicator', chat.currentMode == 'Indicator', () => chat.setMode('Indicator')),
                    const SizedBox(width: 8),
                    _buildModeChip('Strategy', chat.currentMode == 'Strategy', () => chat.setMode('Strategy')),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.chipBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Text(chat.currentVersion, style: AppTypography.labelSm),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down, size: 16),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Chat messages
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chat, _) {
                if (chat.messages.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chat.messages.length + (chat.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == chat.messages.length) {
                      return _buildTypingIndicator();
                    }
                    final message = chat.messages[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ChatBubble(
                          message: message.content,
                          isUser: message.role.name == 'user',
                          imagePath: message.imagePath,
                        ),
                        if (message.codeBlock != null) ...[
                          const SizedBox(height: 8),
                          CodeBlockWidget(
                            code: message.codeBlock!,
                            filename: 'generated.pine',
                            version: 'v6',
                          ),
                        ],
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // Chat input
          ChatInputBar(
            hint: 'Ask for a script or explain code...',
            onSend: (text) {
              context.read<ChatProvider>().sendMessage(text);
              _scrollToBottom();
            },
            onImagePressed: () {},
            showContextChips: true,
          ),
          // Disclaimer
          Padding(
            padding: const EdgeInsets.only(bottom: 4, top: 4),
            child: Text(
              'TrapAI can make mistakes. Verify important financial code.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const TrapAIBottomNav(currentIndex: AppConstants.chatTabIndex),
    );
  }

  Widget _buildModeChip(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.chipBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: isActive ? AppColors.onPrimary : AppColors.chipText,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.smart_toy_outlined, size: 18),
          ),
          const SizedBox(width: 8),
          Row(
            children: List.generate(3, (i) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 600 + i * 200),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.textMuted,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.textMuted.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text('Start a conversation', style: AppTypography.headlineSm.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Text(
            'Ask TrapAI to generate Pine Script code',
            style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

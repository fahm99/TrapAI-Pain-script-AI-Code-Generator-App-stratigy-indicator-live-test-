import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/empty_state.dart';

class PreviousChatsPage extends StatefulWidget {
  const PreviousChatsPage({super.key});

  @override
  State<PreviousChatsPage> createState() => _PreviousChatsPageState();
}

class _PreviousChatsPageState extends State<PreviousChatsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Previous Chats'),
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textMain,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              style: AppTypography.bodyMd,
              onChanged: (v) => context.read<ChatProvider>().searchSessions(v),
              decoration: InputDecoration(
                hintText: 'Search chats...',
                hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textMuted),
                prefixIconConstraints: const BoxConstraints(minWidth: 40),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chat, _) {
          if (chat.sessions.isEmpty) {
            return const EmptyState(
              icon: Icons.chat_bubble_outline,
              title: 'No chats yet',
              subtitle: 'Your conversation history will appear here.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            physics: const BouncingScrollPhysics(),
            itemCount: chat.sessions.length,
            itemBuilder: (context, index) {
              final session = chat.sessions[index];
              return ListTile(
                leading: const Icon(Icons.chat_bubble_outline, size: 20, color: AppColors.textSecondary),
                title: Text(
                  session.title,
                  style: AppTypography.bodyMd.copyWith(color: AppColors.textMain),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  session.lastMessage,
                  style: AppTypography.bodySm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textMuted),
                  onPressed: () => _confirmDelete(context, chat, session.id),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                onTap: () {
                  chat.selectSession(session.id);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, ChatProvider chat, String sessionId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              chat.deleteSession(sessionId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

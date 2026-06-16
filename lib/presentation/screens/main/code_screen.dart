import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/script_provider.dart';
import '../../widgets/trapai_app_bar.dart';
import '../../widgets/trapai_bottom_nav.dart';
import '../../widgets/code_block_widget.dart';
import '../../widgets/chat_input_bar.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScriptProvider>().loadScripts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TrapAIAppBar(),
      body: Consumer<ScriptProvider>(
        builder: (context, script, _) {
          if (script.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (script.currentScript == null) {
            return _buildEmptyState();
          }

          final current = script.currentScript!;
          return Column(
            children: [
              // File metadata
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CURRENT FILE', style: AppTypography.labelCaps),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.description_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text(current.filename, style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.chipBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(current.version, style: AppTypography.labelSm.copyWith(fontSize: 10)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Code editor
              Expanded(
                child: CodeBlockWidget(
                  code: current.content,
                  filename: current.filename,
                  version: current.version,
                  showHeader: true,
                ),
              ),
              // Action buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _copyCode(current.content),
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text('Copy'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _downloadCode(current.content, current.filename),
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('.txt'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _shareCode(current.content),
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('Share'),
                      ),
                    ),
                  ],
                ),
              ),
              // Chat input
              const ChatInputBar(hint: 'Explain this script...'),
            ],
          );
        },
      ),
      bottomNavigationBar: const TrapAIBottomNav(currentIndex: AppConstants.codeTabIndex),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.folder_open, size: 64, color: AppColors.textMuted.withOpacity(0.2)),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.auto_awesome, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('No scripts found', style: AppTypography.headlineSm),
          const SizedBox(height: 8),
          Text(
            'Start a new chat to generate your first Pine Script indicator.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to chat tab
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Chat'),
            ),
          ),
          const SizedBox(height: 24),
          Opacity(
            opacity: 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHintCard(Icons.history, 'History'),
                const SizedBox(width: 12),
                _buildHintCard(Icons.auto_awesome, 'Library', isActive: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintCard(IconData icon, String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.surfaceContainer : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: AppTypography.labelSm),
        ],
      ),
    );
  }

  void _copyCode(String code) {
    // Copy to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  void _downloadCode(String code, String filename) {
    // Download as .txt
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloaded $filename')),
    );
  }

  void _shareCode(String code) {
    // Share code
  }
}

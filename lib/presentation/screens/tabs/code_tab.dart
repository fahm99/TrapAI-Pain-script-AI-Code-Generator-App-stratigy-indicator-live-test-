import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/script_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/code_block_widget.dart';

class CodeTab extends StatelessWidget {
  const CodeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScriptProvider>(
      builder: (context, script, _) {
        if (script.isGenerating) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                const SizedBox(height: 16),
                Text('Generating code...', style: AppTypography.bodyMd),
              ],
            ),
          );
        }

        if (script.generatedCode.isEmpty) {
          return const EmptyState(
            icon: Icons.code,
            title: 'No code yet',
            subtitle: 'Start a conversation in the Chat tab to generate Pine Script code.',
          );
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.code, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text('Generated Code', style: AppTypography.labelSm),
                  const Spacer(),
                  _copyButton(context, script.generatedCode),
                  const SizedBox(width: 8),
                  _formatButton(context),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                child: CodeBlockWidget(code: script.generatedCode),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _copyButton(BuildContext context, String code) {
    return Material(
      color: AppColors.divider,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: code));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text('Copy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _formatButton(BuildContext context) {
    return Material(
      color: AppColors.divider,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text('Format', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

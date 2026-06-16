import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class CodeBlockWidget extends StatelessWidget {
  final String code;
  final String filename;
  final String version;
  final bool showHeader;

  const CodeBlockWidget({
    super.key,
    required this.code,
    required this.filename,
    required this.version,
    this.showHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                if (showHeader) ...[
                  Text(
                    'Pine Script | UTF-8',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onPrimaryContainer,
                      fontFamily: 'JetBrains Mono',
                      fontSize: 10,
                    ),
                  ),
                  const Spacer(),
                ] else ...[
                  Text(
                    'Pinescript ${version.replaceAll('v', 'v')}',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onPrimaryContainer,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied!')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.copy, size: 12, color: AppColors.textMain),
                          const SizedBox(width: 4),
                          Text('Copy', style: AppTypography.labelSm.copyWith(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Code content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: Text(
              code,
              style: AppTypography.codeBlock.copyWith(
                color: AppColors.onPrimary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

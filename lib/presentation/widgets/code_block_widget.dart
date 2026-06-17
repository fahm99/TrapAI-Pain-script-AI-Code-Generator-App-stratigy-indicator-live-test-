import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class CodeBlockWidget extends StatelessWidget {
  final String code;
  final String? filename;
  final String? version;
  final bool showHeader;

  const CodeBlockWidget({
    super.key,
    required this.code,
    this.filename,
    this.version,
    this.showHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D2D),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.code, size: 14, color: Colors.white54),
                const SizedBox(width: 6),
                Text(
                  filename ?? 'Pine Script',
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
                ),
                const Spacer(),
                if (version != null)
                  Text(
                    version!,
                    style: const TextStyle(color: Colors.white38, fontSize: 10),
                  ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              code,
              style: const TextStyle(
                color: Color(0xFFD4D4D4),
                fontSize: 13,
                height: 1.6,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

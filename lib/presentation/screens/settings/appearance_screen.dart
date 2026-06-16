import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/settings_provider.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('TrapAI'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            padding: const EdgeInsets.all(AppConstants.marginEdge),
            children: [
              Text('Appearance', style: AppTypography.headlineLg),
              const SizedBox(height: 4),
              Text(
                'Customize how TrapAI looks on your device.',
                style: AppTypography.bodyMd,
              ),
              const SizedBox(height: 24),

              // Theme selection
              _buildThemeCard(
                context: context,
                title: 'Light Mode',
                subtitle: 'Classic minimalist aesthetic',
                isSelected: settings.themeMode == ThemeMode.light,
                preview: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(height: 4, width: 40, color: AppColors.border),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(height: 16, width: 2, color: AppColors.border),
                          const SizedBox(width: 4),
                          Expanded(child: Container(height: 8, color: AppColors.surfaceContainer)),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () => settings.setThemeMode(ThemeMode.light),
              ),
              const SizedBox(height: 12),
              _buildThemeCard(
                context: context,
                title: 'Dark Mode',
                subtitle: 'Reduced glare for night coding',
                isSelected: settings.themeMode == ThemeMode.dark,
                preview: Container(
                  decoration: BoxDecoration(
                    color: AppColors.chartDarkBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.chartHeaderBg),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(height: 4, width: 40, color: AppColors.chartHeaderBg),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(height: 16, width: 2, color: AppColors.chartHeaderBg),
                          const SizedBox(width: 4),
                          Expanded(child: Container(height: 8, color: AppColors.chartHeaderBg)),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () => settings.setThemeMode(ThemeMode.dark),
              ),
              const SizedBox(height: 12),
              _buildThemeCard(
                context: context,
                title: 'System Default',
                subtitle: 'Syncs with your device settings',
                isSelected: settings.themeMode == ThemeMode.system,
                preview: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 32,
                          color: AppColors.surfaceContainerLowest,
                        ),
                      ),
                      Container(width: 1, color: AppColors.border),
                      Expanded(
                        child: Container(
                          height: 32,
                          color: AppColors.chartDarkBg,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => settings.setThemeMode(ThemeMode.system),
              ),

              const SizedBox(height: 24),

              // Typography settings
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildToggleTile(
                      title: 'Compact View',
                      subtitle: 'Reduce spacing for more content',
                      value: settings.compactView,
                      onChanged: (_) => settings.toggleCompactView(),
                    ),
                    const Divider(),
                    _buildToggleTile(
                      title: 'Monospaced Editor Labels',
                      subtitle: 'Use code font for technical labels',
                      value: settings.monospacedLabels,
                      onChanged: (_) => settings.toggleMonospacedLabels(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Decorative
              Center(
                child: Text(
                  'Interface Engine v2.4.0',
                  style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 10),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isSelected,
    required Widget preview,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTypography.bodySm),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(width: 60, height: 40, child: preview),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodyLg),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTypography.bodySm),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}

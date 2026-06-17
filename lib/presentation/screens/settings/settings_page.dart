import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textMain,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Appearance'),
          const SizedBox(height: 8),
          _themeSelector(settings),
          const SizedBox(height: 24),

          _sectionTitle('Quick Actions'),
          const SizedBox(height: 8),
          _actionTile(Icons.language, 'Language', settings.language, () {}),
          _actionTile(Icons.notifications_outlined, 'Notifications',
              settings.notificationsEnabled ? 'On' : 'Off', () => settings.toggleNotifications()),
          _actionTile(Icons.delete_outline, 'Clear Cache', '', () {
            settings.clearCache();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cache cleared'), duration: Duration(seconds: 1)),
            );
          }),
          const SizedBox(height: 24),

          _sectionTitle('About'),
          const SizedBox(height: 8),
          _infoTile('Version', '1.0.0'),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: AppTypography.labelCaps);
  }

  Widget _themeSelector(SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          _themeOption('Light', Icons.light_mode_outlined, ThemeModeOption.light, settings),
          _themeOption('Dark', Icons.dark_mode_outlined, ThemeModeOption.dark, settings),
          _themeOption('Auto', Icons.brightness_auto_outlined, ThemeModeOption.auto, settings),
        ],
      ),
    );
  }

  Widget _themeOption(String label, IconData icon, ThemeModeOption mode, SettingsProvider settings) {
    final isSelected = settings.themeMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => settings.setThemeMode(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: isSelected ? Colors.white : AppColors.textMuted),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionTile(IconData icon, String title, String trailing, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.textMain),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: AppTypography.bodyMd)),
                if (trailing.isNotEmpty)
                  Text(trailing, style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(title, style: AppTypography.bodyMd),
          const Spacer(),
          Text(value, style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

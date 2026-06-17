import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/settings_provider.dart';

class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

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
        title: const Text('General Settings'),
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textMain,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _sectionHeader('Appearance'),
          _themeTile('Light', ThemeModeOption.light, settings),
          _themeTile('Dark', ThemeModeOption.dark, settings),
          _themeTile('Auto (System)', ThemeModeOption.auto, settings),
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),

          _sectionHeader('Language'),
          ListTile(
            title: Text('Language', style: AppTypography.bodyMd),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(settings.language, style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
              ],
            ),
            onTap: () => _showLanguagePicker(context, settings),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),

          _sectionHeader('Notifications'),
          SwitchListTile(
            title: Text('Push Notifications', style: AppTypography.bodyMd),
            value: settings.notificationsEnabled,
            onChanged: (_) => settings.toggleNotifications(),
            activeColor: AppColors.primary,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),

          _sectionHeader('Data & Storage'),
          ListTile(
            title: Text('Clear Cache', style: AppTypography.bodyMd),
            subtitle: Text('Free up local storage', style: AppTypography.bodySm),
            trailing: const Icon(Icons.delete_outline, size: 20, color: AppColors.textMuted),
            onTap: () => _confirmClearCache(context, settings),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),

          _sectionHeader('Permissions'),
          ListTile(
            title: Text('Manage Permissions', style: AppTypography.bodyMd),
            subtitle: Text('Camera, Storage, Notifications', style: AppTypography.bodySm),
            trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),

          _sectionHeader('About'),
          ListTile(
            title: Text('App Version', style: AppTypography.bodyMd),
            trailing: Text('1.0.0', style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted)),
          ),
          ListTile(
            title: Text('Terms of Service', style: AppTypography.bodyMd),
            trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            title: Text('Privacy Policy', style: AppTypography.bodyMd),
            trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title, style: AppTypography.labelCaps),
    );
  }

  Widget _themeTile(String label, ThemeModeOption mode, SettingsProvider settings) {
    final isSelected = settings.themeMode == mode;
    return RadioListTile<ThemeModeOption>(
      value: mode,
      groupValue: settings.themeMode,
      onChanged: (_) => settings.setThemeMode(mode),
      title: Text(label, style: AppTypography.bodyMd),
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  void _showLanguagePicker(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text('Select Language', style: AppTypography.headlineSm),
              const SizedBox(height: 8),
              ...['English', 'Arabic', 'Spanish', 'French'].map((lang) => ListTile(
                    title: Text(lang, style: AppTypography.bodyMd),
                    trailing: settings.language == lang
                        ? const Icon(Icons.check, color: AppColors.primary, size: 20)
                        : null,
                    onTap: () {
                      settings.setLanguage(lang);
                      Navigator.pop(context);
                    },
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _confirmClearCache(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all temporary data. This action cannot be undone.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              settings.clearCache();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared'), duration: Duration(seconds: 1)),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

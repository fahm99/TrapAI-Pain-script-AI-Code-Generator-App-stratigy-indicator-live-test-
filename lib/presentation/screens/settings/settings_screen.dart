import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/trapai_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TrapAIAppBar(showMenuButton: false),
      body: Consumer2<SettingsProvider, AuthProvider>(
        builder: (context, settings, auth, _) {
          return ListView(
            padding: const EdgeInsets.all(AppConstants.marginEdge),
            children: [
              Text('Settings', style: AppTypography.headlineLg),
              const SizedBox(height: 4),
              Text('Manage your preferences and app configuration.', style: AppTypography.bodyMd),
              const SizedBox(height: 24),

              // Preferences
              _buildSectionHeader('PREFERENCES'),
              _buildSettingsTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: settings.language,
                onTap: () => _showLanguagePicker(context, settings),
              ),
              _buildSettingsTile(
                icon: Icons.monetization_on_outlined,
                title: 'Currency',
                subtitle: settings.currency,
                onTap: () {},
              ),

              const SizedBox(height: 24),

              // Data Source
              _buildSectionHeader('DATA SOURCE'),
              _buildSettingsTile(
                icon: Icons.show_chart,
                title: 'Chart Provider',
                subtitle: settings.chartProvider,
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.api,
                title: 'API Connections',
                subtitle: '3 Active keys',
                onTap: () {},
              ),

              const SizedBox(height: 24),

              // About
              _buildSectionHeader('ABOUT'),
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'App Version',
                subtitle: '${AppConstants.appVersion} stable build',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.chipBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('LATEST', style: AppTypography.labelSm.copyWith(fontSize: 10)),
                ),
              ),
              _buildSettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // Logout
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    auth.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text('Log out', style: TextStyle(color: AppColors.error)),
                ),
              ),

              const SizedBox(height: 24),

              // Footer
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text('Privacy', style: AppTypography.bodySm),
                      ),
                      Text(' | ', style: AppTypography.bodySm),
                      TextButton(
                        onPressed: () {},
                        child: Text('Security', style: AppTypography.bodySm),
                      ),
                      Text(' | ', style: AppTypography.bodySm),
                      TextButton(
                        onPressed: () {},
                        child: Text('Help', style: AppTypography.bodySm),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Securely encrypted by TrapAI Node',
                    style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 10),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const _SettingsBottomNav(currentIndex: AppConstants.settingsTabIndex),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: AppTypography.labelCaps),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(title, style: AppTypography.bodyLg),
      subtitle: subtitle != null ? Text(subtitle, style: AppTypography.bodySm) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _showLanguagePicker(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text('Select Language', style: AppTypography.headlineSm),
              const SizedBox(height: 16),
              _buildLanguageOption(context, 'English (US)', settings),
              _buildLanguageOption(context, 'العربية', settings),
              _buildLanguageOption(context, 'Français', settings),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String lang, SettingsProvider settings) {
    final isSelected = settings.language == lang;
    return ListTile(
      title: Text(lang),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        settings.setLanguage(lang);
        Navigator.pop(context);
      },
    );
  }
}

class _SettingsBottomNav extends StatelessWidget {
  final int currentIndex;

  const _SettingsBottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Chart'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.code), label: 'Code'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: (index) {
        if (index != currentIndex) {
          Navigator.pushReplacementNamed(context, '/home', arguments: index);
        }
      },
    );
  }
}

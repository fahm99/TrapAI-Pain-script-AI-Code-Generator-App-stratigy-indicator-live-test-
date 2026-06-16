import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/settings_provider.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.marginEdge),
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.surfaceContainer,
                      child: Icon(Icons.person, size: 40, color: AppColors.textSecondary),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 14, color: AppColors.onPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Pine Developer', style: AppTypography.headlineSm),
                const SizedBox(height: 4),
                Text('pine.dev@trapai.io', style: AppTypography.bodyMd),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'PRO TIER',
                    style: AppTypography.labelSm.copyWith(color: AppColors.onPrimaryContainer, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Account Security
          Text('ACCOUNT SECURITY', style: AppTypography.labelCaps),
          const SizedBox(height: 8),

          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your identity and bio',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Manage your account credentials',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.security,
            title: 'Two-Factor Auth',
            subtitle: 'OFF',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('OFF', style: AppTypography.labelSm.copyWith(color: AppColors.onErrorContainer, fontSize: 10)),
            ),
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notification Preferences',
            subtitle: 'Control push and email alerts',
            onTap: () {},
          ),

          const SizedBox(height: 32),

          // Danger zone
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              '${AppConstants.appVersion} • ${AppConstants.buildNumber}',
              style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
            ),
          ),
        ],
      ),
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
}

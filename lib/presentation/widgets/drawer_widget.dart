import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surfaceContainerLowest,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.surfaceContainer,
                    child: Icon(Icons.person, size: 28, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pine Developer', style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Pro Tier',
                                style: AppTypography.labelSm.copyWith(
                                  fontSize: 9,
                                  color: AppColors.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('v1.0.4', style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Navigation items
            _buildNavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              isActive: true,
              onTap: () {},
            ),
            _buildNavItem(
              icon: Icons.history,
              label: 'History',
              onTap: () {},
            ),
            _buildNavItem(
              icon: Icons.folder_special,
              label: 'Library',
              onTap: () {},
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Preferences', style: AppTypography.labelCaps),
            ),
            const SizedBox(height: 8),

            _buildNavItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),

            const Spacer(),

            // Logout
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.error, size: 22),
                    title: const Text('Log out', style: TextStyle(color: AppColors.error)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Designed for precision algorithmic trading on TradingView.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 22,
        color: isActive ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        label,
        style: AppTypography.bodyLg.copyWith(
          color: isActive ? AppColors.primary : AppColors.textMain,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      tileColor: isActive ? AppColors.surfaceContainerHigh.withOpacity(0.3) : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

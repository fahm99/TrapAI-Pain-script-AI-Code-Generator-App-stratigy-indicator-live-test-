import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SupportHelpPage extends StatelessWidget {
  const SupportHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Support & Help'),
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textMain,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('FAQ'),
          _faqItem('How do I generate a Pine Script?', 'Simply describe what you want in the Chat tab, and TrapAI will generate the code for you.'),
          _faqItem('What Pine Script versions are supported?', 'TrapAI supports both Pine Script v5 and v6. You can select the version in the chat input.'),
          _faqItem('Can I upload chart images?', 'Yes! You can attach chart images when sending a prompt, and TrapAI will analyze them.'),
          const SizedBox(height: 24),

          _sectionHeader('Contact Us'),
          _contactTile(Icons.email_outlined, 'Email Support', 'support@trapai.com'),
          _contactTile(Icons.chat_bubble_outline, 'Live Chat', 'Available 24/7'),
          _contactTile(Icons.group_outlined, 'Community Forum', 'Join our community'),
          const SizedBox(height: 24),

          _sectionHeader('Legal'),
          _linkTile('Privacy Policy', Icons.lock_outline),
          _linkTile('Terms of Service', Icons.description_outlined),
          _linkTile('Cookie Policy', Icons.cookie_outlined),
          const SizedBox(height: 32),

          Center(
            child: Text('TrapAI v1.0.0', style: AppTypography.bodySm),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: AppTypography.headlineSm),
    );
  }

  Widget _faqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(question, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600)),
        children: [Text(answer, style: AppTypography.bodyMd)],
      ),
    );
  }

  Widget _contactTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, size: 22, color: AppColors.textMain),
      title: Text(title, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: AppTypography.bodySm),
      trailing: const Icon(Icons.open_in_new, size: 16, color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _linkTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, size: 20, color: AppColors.textSecondary),
      title: Text(title, style: AppTypography.bodyMd),
      trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

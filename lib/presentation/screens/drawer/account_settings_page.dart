import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/auth_provider.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _nameController = TextEditingController(text: auth.userName ?? '');
    _emailController = TextEditingController(text: auth.userEmail ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Account Settings'),
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textMain,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              if (_isEditing) {
                auth.updateProfile(
                  name: _nameController.text,
                  email: _emailController.text,
                );
              }
              setState(() => _isEditing = !_isEditing);
            },
            child: Text(_isEditing ? 'Save' : 'Edit', style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Text(
                (auth.userName ?? 'U')[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildField('Name', _nameController, _isEditing),
          const SizedBox(height: 16),
          _buildField('Email', _emailController, _isEditing),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 32),
          _sectionTitle('Danger Zone'),
          const SizedBox(height: 12),
          _dangerButton('Delete Account', () => _confirmDelete(context)),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, bool enabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelCaps),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          style: AppTypography.bodyMd.copyWith(color: AppColors.textMain),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? AppColors.surfaceContainerLowest : AppColors.divider,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password', style: AppTypography.labelCaps),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: const BorderSide(color: AppColors.border),
          ),
          child: Text('Change Password', style: AppTypography.bodyMd.copyWith(color: AppColors.textMain)),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: AppTypography.labelCaps.copyWith(color: AppColors.error));
  }

  Widget _dangerButton(String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: AppColors.error),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action cannot be undone. All your data will be permanently deleted.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

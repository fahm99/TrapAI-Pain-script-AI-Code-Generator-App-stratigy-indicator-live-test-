import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class TrapAIAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final bool showMenuButton;

  const TrapAIAppBar({
    super.key,
    this.onMenuPressed,
    this.showMenuButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.surfaceContainer,
          child: const Icon(Icons.person, size: 18, color: AppColors.textSecondary),
        ),
      ),
      title: const Text('TrapAI'),
      actions: [
        if (showMenuButton)
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onMenuPressed ?? () {},
          ),
      ],
    );
  }
}

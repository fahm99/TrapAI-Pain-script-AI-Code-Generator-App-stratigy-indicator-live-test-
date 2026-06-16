import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrapAI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.marginEdge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 2),
            // Error icon
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: AppTypography.headlineLg,
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              'The Pine Script engine encountered an unexpected runtime exception. Please try again or contact support.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: 24),
            // System logs
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                'TypeError: Cannot read property \'strategy\' of undefined\n  at PineEngine.execute (pine-engine.js:142)\n  at ScriptRunner.run (script-runner.js:89)\n  at ModuleLoader.load (module-loader.js:23)',
                style: AppTypography.codeBlock.copyWith(fontSize: 11),
              ),
            ),
            const SizedBox(height: 32),
            // Actions
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.support_agent, size: 18),
              label: const Text('Contact Support'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: Text(
                'Need more help? View documentation',
                style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
              ),
            ),
            const Spacer(flex: 3),
            // Footer
            Center(
              child: Text(
                '© 2024 TrapAI Ecosystem',
                style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 10),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

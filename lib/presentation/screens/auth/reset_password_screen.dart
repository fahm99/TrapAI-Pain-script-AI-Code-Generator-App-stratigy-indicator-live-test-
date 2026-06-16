import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/trapai_logo.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const TrapAILogo(fontSize: 18),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: 60,
            right: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle, width: 1),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -20,
            child: Transform.rotate(
              angle: 0.785,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderSubtle, width: 1),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginEdge),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      _isSent ? 'Link Sent' : 'Reset Password',
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineLg,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isSent
                          ? 'Check your email for the reset link'
                          : 'Enter your email to receive a link',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMd,
                    ),
                    const SizedBox(height: 32),
                    if (_isSent) ...[
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: const Icon(Icons.check_circle, color: AppColors.onPrimary, size: 36),
                        ),
                      ),
                      const SizedBox(height: 32),
                      OutlinedButton(
                        onPressed: () {
                          setState(() => _isSent = false);
                          _emailController.clear();
                        },
                        child: const Text('Try another email'),
                      ),
                    ] else ...[
                      TextFormField(
                        controller: _emailController,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'name@company.com',
                          prefixIcon: Icon(Icons.email_outlined, size: 20),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return ElevatedButton(
                            onPressed: auth.isLoading ? null : _handleReset,
                            child: auth.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Send Reset Link'),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 32),
                    // Decorative bento grid
                    Opacity(
                      opacity: 0.6,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.shield_outlined, size: 20),
                                  const SizedBox(height: 8),
                                  Text('Encrypted Protocol', style: AppTypography.labelSm),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.timer_outlined, size: 20),
                                  const SizedBox(height: 8),
                                  Text('Link expires in 1h', style: AppTypography.labelSm),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back to Login'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'TrapAI - Systematic Algorithmic Trading',
                        style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleReset() async {
    if (_formKey.currentState!.validate()) {
      final auth = context.read<AuthProvider>();
      await auth.resetPassword(_emailController.text.trim());
      if (mounted) {
        setState(() => _isSent = true);
      }
    }
  }
}
 
 / /   R e s e t   p a s s w o r d   i m p r o v e m e n t s  
 
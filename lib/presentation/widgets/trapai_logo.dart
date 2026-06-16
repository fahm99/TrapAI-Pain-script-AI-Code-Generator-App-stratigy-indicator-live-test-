import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class TrapAILogo extends StatelessWidget {
  final double fontSize;

  const TrapAILogo({super.key, this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    return Text(
      'TrapAI',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        color: AppColors.textMain,
        letterSpacing: -0.02,
      ),
    );
  }
}

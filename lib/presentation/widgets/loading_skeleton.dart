import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class LoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LoadingSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.borderSubtle,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ChatSkeleton extends StatelessWidget {
  const ChatSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bot message skeleton
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.borderSubtle,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoadingSkeleton(width: 80, height: 12),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          LoadingSkeleton(height: 12),
                          SizedBox(height: 6),
                          LoadingSkeleton(width: 200, height: 12),
                          SizedBox(height: 6),
                          LoadingSkeleton(width: 160, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Code block skeleton
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(5, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: LoadingSkeleton(
                    width: 120.0 + (i * 40),
                    height: 10,
                    borderRadius: 4,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          // User message skeleton
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const LoadingSkeleton(width: 180, height: 14),
            ),
          ),
        ],
      ),
    );
  }
}

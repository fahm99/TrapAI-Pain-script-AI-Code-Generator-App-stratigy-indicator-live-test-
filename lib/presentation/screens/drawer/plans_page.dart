import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Plans & Subscriptions'),
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textMain,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildCurrentPlan(),
          const SizedBox(height: 24),
          Text('Available Plans', style: AppTypography.headlineSm),
          const SizedBox(height: 16),
          _planCard(
            name: 'Free',
            price: '\$0',
            period: '/forever',
            features: ['5 scripts / month', 'Basic indicators', 'Community support'],
            isSelected: true,
            onUpgrade: null,
          ),
          const SizedBox(height: 12),
          _planCard(
            name: 'Pro',
            price: '\$19',
            period: '/month',
            features: ['Unlimited scripts', 'Advanced indicators', 'Priority support', 'Custom strategies', 'API access'],
            isSelected: false,
            onUpgrade: () {},
          ),
          const SizedBox(height: 12),
          _planCard(
            name: 'Enterprise',
            price: '\$99',
            period: '/month',
            features: ['Everything in Pro', 'Team collaboration', 'Dedicated support', 'Custom integrations', 'SLA guarantee'],
            isSelected: false,
            onUpgrade: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlan() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_outline, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Current Plan', style: AppTypography.labelCaps.copyWith(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Free', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('3 of 5 scripts used', style: AppTypography.bodySm.copyWith(color: Colors.white70)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.8)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _planCard({
    required String name,
    required String price,
    required String period,
    required List<String> features,
    required bool isSelected,
    VoidCallback? onUpgrade,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(name, style: AppTypography.headlineSm),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Current', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textMain)),
              Text(period, style: AppTypography.bodySm),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.check, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(f, style: AppTypography.bodyMd)),
              ],
            ),
          )),
          if (onUpgrade != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onUpgrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Upgrade'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

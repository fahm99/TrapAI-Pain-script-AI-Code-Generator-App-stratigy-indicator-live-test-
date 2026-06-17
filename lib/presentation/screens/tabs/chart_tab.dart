import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/empty_state.dart';

class ChartTab extends StatelessWidget {
  const ChartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.candlestick_chart, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text('Chart Preview', style: AppTypography.labelSm),
              const Spacer(),
              _symbolDropdown(),
            ],
          ),
        ),
        Expanded(
          child: _buildChartContent(context),
        ),
      ],
    );
  }

  Widget _buildChartContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            height: 300,
            decoration: BoxDecoration(
              color: const Color(0xFF131722),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.candlestick_chart, size: 48, color: Color(0xFF2962FF)),
                  SizedBox(height: 12),
                  Text(
                    'Chart Preview',
                    style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'TradingView widget will appear here',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Apply generated indicators to see them on the chart.',
              style: AppTypography.bodySm,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _symbolDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'BTC/USDT',
          isDense: true,
          style: AppTypography.labelText.copyWith(color: AppColors.textMain),
          icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textMuted),
          items: const [
            DropdownMenuItem(value: 'BTC/USDT', child: Text('BTC/USDT')),
            DropdownMenuItem(value: 'ETH/USDT', child: Text('ETH/USDT')),
            DropdownMenuItem(value: 'SOL/USDT', child: Text('SOL/USDT')),
          ],
          onChanged: (_) {},
        ),
      ),
    );
  }
}

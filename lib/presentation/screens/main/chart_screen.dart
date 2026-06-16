import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/trapai_app_bar.dart';
import '../../widgets/trapai_bottom_nav.dart';
import '../../widgets/chat_input_bar.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String _selectedTimeframe = '15m';
  String _symbol = 'BTCUSD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TrapAIAppBar(),
      body: Column(
        children: [
          // Chart controls bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                // Symbol search
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 16),
                      const SizedBox(width: 4),
                      Text(_symbol, style: AppTypography.labelSm),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Timeframe selectors
                ...AppConstants.chartTimeframes.map((tf) {
                  final isSelected = tf == _selectedTimeframe;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTimeframe = tf),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tf,
                          style: AppTypography.labelSm.copyWith(
                            color: isSelected ? AppColors.onPrimary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Chart container
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.chartDarkBg,
              child: Column(
                children: [
                  // Chart header bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: AppColors.chartHeaderBg,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.chartRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'BITSTAMP | BTC / USD',
                          style: AppTypography.labelSm.copyWith(color: AppColors.chartText),
                        ),
                        const Spacer(),
                        Text(
                          '65,825.99',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.chartRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '-2.4%',
                          style: AppTypography.labelSm.copyWith(color: AppColors.chartRed),
                        ),
                      ],
                    ),
                  ),
                  // Chart area (placeholder)
                  Expanded(
                    child: Stack(
                      children: [
                        // Candlestick chart placeholder
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.show_chart, size: 64, color: AppColors.chartText.withOpacity(0.3)),
                              const SizedBox(height: 16),
                              Text(
                                'TradingView Chart',
                                style: AppTypography.bodyLg.copyWith(color: AppColors.chartText.withOpacity(0.5)),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Live chart integration here',
                                style: AppTypography.bodySm.copyWith(color: AppColors.chartText.withOpacity(0.3)),
                              ),
                            ],
                          ),
                        ),
                        // Floating legend
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.chartHeaderBg.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text('TrapAI Engine v4.2', style: AppTypography.labelSm.copyWith(color: AppColors.chartText, fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.chartHeaderBg.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.chartRed,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text('Sell Pressure: High', style: AppTypography.labelSm.copyWith(color: AppColors.chartRed, fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Chat input bar
          const ChatInputBar(hint: 'Ask for an indicator...'),
        ],
      ),
      bottomNavigationBar: const TrapAIBottomNav(currentIndex: AppConstants.chartTabIndex),
    );
  }
}
 
 / /   C h a r t   i m p r o v e m e n t s  
 
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ChartTab extends StatefulWidget {
  const ChartTab({super.key});

  @override
  State<ChartTab> createState() => _ChartTabState();
}

class _ChartTabState extends State<ChartTab> {
  String _selectedSymbol = 'BTCUSDT';
  String _selectedInterval = '1H';

  static const Map<String, String> _symbols = {
    'BTCUSDT': 'Bitcoin',
    'ETHUSDT': 'Ethereum',
    'SOLUSDT': 'Solana',
    'BNBUSDT': 'BNB',
    'XRPUSDT': 'XRP',
  };

  static const List<String> _intervals = ['1m', '5m', '15m', '1H', '4H', '1D', '1W'];

  List<_Candle> _generateCandles(int count) {
    final random = Random(42);
    final candles = <_Candle>[];
    double price = 67000;
    for (int i = 0; i < count; i++) {
      final change = (random.nextDouble() - 0.48) * 800;
      final open = price;
      final close = price + change;
      final high = max(open, close) + random.nextDouble() * 400;
      final low = min(open, close) - random.nextDouble() * 400;
      candles.add(_Candle(open: open, high: high, low: low, close: close));
      price = close;
    }
    return candles;
  }

  @override
  Widget build(BuildContext context) {
    final candles = _generateCandles(60);
    final lastCandle = candles.last;
    final change = lastCandle.close - candles[candles.length - 2].close;
    final changePercent = (change / candles[candles.length - 2].close * 100);
    final isUp = change >= 0;

    return Column(
      children: [
        _buildChartHeader(isUp, lastCandle, change, changePercent),
        _buildIntervalBar(),
        Expanded(
          child: _ChartPainter(candles: candles),
        ),
        _buildBottomInfo(lastCandle),
      ],
    );
  }

  Widget _buildChartHeader(bool isUp, _Candle last, double change, double percent) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          _symbolDropdown(),
          const SizedBox(width: 12),
          Text(
            '\$${last.close.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isUp ? '+' : ''}${change.toStringAsFixed(2)} (${isUp ? '+' : ''}${percent.toStringAsFixed(2)}%)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isUp ? const Color(0xFF26A69A) : const Color(0xFFF7525F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _symbolDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSymbol,
          isDense: true,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMain),
          icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textMuted),
          items: _symbols.entries.map((e) => DropdownMenuItem(
            value: e.key,
            child: Text(e.key),
          )).toList(),
          onChanged: (v) => setState(() => _selectedSymbol = v!),
        ),
      ),
    );
  }

  Widget _buildIntervalBar() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          for (final interval in _intervals) ...[
            GestureDetector(
              onTap: () => setState(() => _selectedInterval = interval),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _selectedInterval == interval ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  interval,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _selectedInterval == interval ? Colors.white : AppColors.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          const Spacer(),
          GestureDetector(
            onTap: () => _openTradingView(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.open_in_new, size: 14, color: AppColors.textMuted),
                  SizedBox(width: 4),
                  Text('TradingView', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo(_Candle last) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoItem('O', last.open.toStringAsFixed(2)),
          _infoItem('H', last.high.toStringAsFixed(2)),
          _infoItem('L', last.low.toStringAsFixed(2)),
          _infoItem('C', last.close.toStringAsFixed(2)),
          _infoItem('Vol', '${(Random().nextDouble() * 1000).toStringAsFixed(0)}K'),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textMain, fontFamily: 'monospace')),
      ],
    );
  }

  Future<void> _openTradingView() async {
    final symbol = _selectedSymbol.replaceAll('USDT', '');
    final url = Uri.parse('https://www.tradingview.com/chart/?symbol=BINANCE:${symbol}USDT');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

class _Candle {
  final double open, high, low, close;
  const _Candle({required this.open, required this.high, required this.low, required this.close});
}

class _ChartPainter extends StatelessWidget {
  final List<_Candle> candles;
  const _ChartPainter({required this.candles});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final allPrices = candles.expand((c) => [c.high, c.low]).toList();
        final minPrice = allPrices.reduce(min);
        final maxPrice = allPrices.reduce(max);
        final priceRange = maxPrice - minPrice;
        final padding = priceRange * 0.05;
        final adjustedMin = minPrice - padding;
        final adjustedMax = maxPrice + padding;
        final adjustedRange = adjustedMax - adjustedMin;

        return Container(
          color: const Color(0xFF131722),
          child: CustomPaint(
            size: Size.infinite,
            painter: _CandlestickPainter(
              candles: candles,
              minPrice: adjustedMin,
              maxPrice: adjustedMax,
            ),
          ),
        );
      },
    );
  }
}

class _CandlestickPainter extends CustomPainter {
  final List<_Candle> candles;
  final double minPrice;
  final double maxPrice;

  _CandlestickPainter({required this.candles, required this.minPrice, required this.maxPrice});

  @override
  void paint(Canvas canvas, Size size) {
    final priceRange = maxPrice - minPrice;
    if (priceRange <= 0) return;

    final candleWidth = size.width / candles.length;
    final bodyWidth = candleWidth * 0.6;

    final gridPaint = Paint()
      ..color = const Color(0xFF1E222D)
      ..strokeWidth = 0.5;

    for (int i = 0; i < 6; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = i * candleWidth + candleWidth / 2;
      final isUp = c.close >= c.open;

      final green = Paint()..color = const Color(0xFF26A69A);
      final red = Paint()..color = const Color(0xFFF7525F);
      final paint = isUp ? green : red;

      final highY = (1 - (c.high - minPrice) / priceRange) * size.height;
      final lowY = (1 - (c.low - minPrice) / priceRange) * size.height;
      final openY = (1 - (c.open - minPrice) / priceRange) * size.height;
      final closeY = (1 - (c.close - minPrice) / priceRange) * size.height;

      canvas.drawLine(Offset(x, highY), Offset(x, lowY), paint..strokeWidth = 1);

      final bodyTop = min(openY, closeY);
      final bodyHeight = (openY - closeY).abs();
      canvas.drawRect(
        Rect.fromLTWH(x - bodyWidth / 2, bodyTop, bodyWidth, max(bodyHeight, 1)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

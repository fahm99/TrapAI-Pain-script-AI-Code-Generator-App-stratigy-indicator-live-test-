class AppConstants {
  AppConstants._();

  static const String appName = 'TrapAI';
  static const String appTagline = 'Systematic Algorithmic Trading';
  static const String appVersion = 'v1.0.4';
  static const String buildNumber = 'Build 882';

  // Spacing
  static const double marginEdge = 16;
  static const double gutter = 12;
  static const double stackSm = 8;
  static const double stackMd = 16;
  static const double stackLg = 24;

  // Border Radius
  static const double radiusSm = 4;
  static const double radiusDefault = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 9999;

  // Timeouts
  static const int apiTimeoutSeconds = 30;
  static const int otpResendSeconds = 120;

  // Pine Script versions
  static const List<String> pineScriptVersions = ['v5', 'v6'];
  static const String defaultPineVersion = 'v6';

  // Timeframes
  static const List<String> chartTimeframes = ['1m', '5m', '15m', '1h', '4h', '1D'];
  static const String defaultTimeframe = '15m';

  // Navigation
  static const int chartTabIndex = 0;
  static const int chatTabIndex = 1;
  static const int codeTabIndex = 2;
  static const int settingsTabIndex = 3;

  // Chat modes
  static const String modeIndicator = 'Indicator';
  static const String modeStrategy = 'Strategy';
}

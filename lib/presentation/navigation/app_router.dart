import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/auth/success_screen.dart';
import '../screens/main/home_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/account_settings_screen.dart';
import '../screens/settings/appearance_screen.dart';
import '../screens/error/error_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String resetPassword = '/reset-password';
  static const String success = '/success';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String accountSettings = '/account-settings';
  static const String appearance = '/appearance';
  static const String error = '/error';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case otp:
        return MaterialPageRoute(builder: (_) => const OTPScreen());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case success:
        return MaterialPageRoute(builder: (_) => const SuccessScreen());
      case home:
        final tabIndex = settings.arguments as int? ?? 1;
        return MaterialPageRoute(builder: (_) => HomeScreen(initialIndex: tabIndex));
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case accountSettings:
        return MaterialPageRoute(builder: (_) => const AccountSettingsScreen());
      case appearance:
        return MaterialPageRoute(builder: (_) => const AppearanceScreen());
      case error:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}

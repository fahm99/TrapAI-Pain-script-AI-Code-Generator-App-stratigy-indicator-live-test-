import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/auth/success_screen.dart';
import '../screens/main/main_shell.dart';
import '../screens/error/error_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String resetPassword = '/reset-password';
  static const String success = '/success';
  static const String home = '/home';
  static const String error = '/error';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
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
        return MaterialPageRoute(builder: (_) => const MainShell());
      case error:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}

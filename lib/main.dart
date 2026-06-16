import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/mock_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/repositories/script_repository_impl.dart';
import 'presentation/navigation/app_router.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/chat_provider.dart';
import 'presentation/providers/script_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/auth/login_screen.dart';

void main() {
  runApp(const TrapAIApp());
}

class TrapAIApp extends StatelessWidget {
  const TrapAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = MockDataSource.instance;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthRepositoryImpl(dataSource)),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(ChatRepositoryImpl(dataSource)),
        ),
        ChangeNotifierProvider(
          create: (_) => ScriptProvider(ScriptRepositoryImpl(dataSource)),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'TrapAI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.lightTheme,
            themeMode: settings.themeMode,
            home: const LoginScreen(),
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}

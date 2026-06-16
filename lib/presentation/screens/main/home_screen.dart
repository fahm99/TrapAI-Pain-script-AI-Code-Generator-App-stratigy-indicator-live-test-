import 'package:flutter/material.dart';
import '../screens/main/chart_screen.dart';
import '../screens/main/chat_screen.dart';
import '../screens/main/code_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/trapai_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 1});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ChartScreen(),
          ChatScreen(),
          CodeScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _currentIndex < 3
          ? TrapAIBottomNav(currentIndex: _currentIndex)
          : null,
    );
  }
}

import 'package:flutter/material.dart';

class TrapAIBottomNav extends StatelessWidget {
  final int currentIndex;

  const TrapAIBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          activeIcon: Icon(Icons.bar_chart),
          label: 'Chart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat_bubble),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.code),
          activeIcon: Icon(Icons.code),
          label: 'Code',
        ),
      ],
      onTap: (index) {
        if (index != currentIndex) {
          Navigator.pushReplacementNamed(context, '/home', arguments: index);
        }
      },
    );
  }
}

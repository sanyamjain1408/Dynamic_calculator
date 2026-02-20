import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/cal_logo.png'),
            size: 24,
          ),
           label: 'Calc',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/smartcalc_logo.png'),
            size: 24,
          ),
           label: 'Smart Calc',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/history_logo.png'),
            size: 24,
          ),
           label: 'History',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/profile_logo.png'),
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
      backgroundColor: Colors.blue[400],
      fixedColor: Colors.white,
    );
  }
}

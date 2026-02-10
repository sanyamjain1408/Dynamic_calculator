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
          label: 'Calculator',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/ca_logo.png'),
            size: 24,
          ),
          label: 'CA',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/bank_logo.png'),
            size: 24,
          ),
          label: 'Bank',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/inc_logo.png'),
            size: 24,
          ),
          label: 'Insurance',
        ),
      ],
      backgroundColor: Colors.blue[400],
      fixedColor: Colors.white,
    );
  }
}

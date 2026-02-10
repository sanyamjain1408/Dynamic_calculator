import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const AppHeader({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.blue[50],
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Center Logo
            Image.asset(
              'assets/smartcalc.png',
              height: 36,
            ),

            /// Left profile
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  print("Avatar tapped"); // debug
                 scaffoldKey?.currentState?.openDrawer();
                },
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/profile_logo.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

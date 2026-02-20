import 'dart:async';


import 'package:calculator/Home/home_screen.dart';
import 'package:calculator/Home/onboarding_screen.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
    super.initState();

   Timer(const Duration(seconds: 3), () {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 800),
    ),
  );
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset('assets/splashpicture.png', height: 146, width: 150,),
            const SizedBox(height: 1,),

            Image.asset('assets/smartcalc.png', height: 38, width: 232,),
            const SizedBox(height: 1,),

            const Text("Professional Calculations Made Easy" , style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),)

          ],)
          
      ),
      ),
    );
  }
}
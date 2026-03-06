import 'package:calculator/Home/emaillogin_screen.dart';
import 'package:flutter/material.dart';
import 'package:calculator/Home/onboarding_screen2.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {

int currentIndex = 1; // active dot index 

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // IMAGE
          Image.asset(
            'assets/onboarding2.png',
            height: 280,
          ),

          const SizedBox(height: 25),

          // TITLE
          const Text(
            'All Calculations in One Place',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // SUB TITLE
          const Text(
            'EMI, GST, Percentage, Unit conversion, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 40),

          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: currentIndex == index ? 10 : 8,
                  height: currentIndex == index ? 10 : 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.blue
                        : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: (){
                Navigator.push(context,
                 MaterialPageRoute(
                  builder: (context) => const EmailLoginScreen()
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C4FF),
               fixedSize: const Size(250, 50),
              ),
              child: const Text("Get Started",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.normal
              ),),
            )
        ],
      ),
    ),
  );

}
}
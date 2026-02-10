import 'package:flutter/material.dart';

class InsurencePremiumScreen extends StatefulWidget {
  const InsurencePremiumScreen({super.key});

  @override
  State<InsurencePremiumScreen> createState() => _InsurencePremiumScreenState();
}

class _InsurencePremiumScreenState extends State<InsurencePremiumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Insurance Premium Calculator",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Add your Insurance Premium calculator UI here
            ],
          ),
        ),
      ),
    );
  }
}
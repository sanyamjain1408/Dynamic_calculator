import 'package:flutter/material.dart';

class InsuranceTermScreen extends StatefulWidget {
  const InsuranceTermScreen({super.key});

  @override
  State<InsuranceTermScreen> createState() => _InsuranceTermScreenState();
}


class _InsuranceTermScreenState extends State<InsuranceTermScreen> {
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
                "Insurance Term Calculator",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Add your Insurance Term calculator UI here
            ],
          ),
        ),
      ),
    );
  }
}
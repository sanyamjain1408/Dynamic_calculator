import 'package:flutter/material.dart';

class InsuranceMaturityScreen extends StatefulWidget {
  const InsuranceMaturityScreen({super.key});

  @override
  State<InsuranceMaturityScreen> createState() => _InsuranceMaturityScreenState();
}

class _InsuranceMaturityScreenState extends State<InsuranceMaturityScreen> {
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
                "Insurance Maturity Calculator",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Add your Insurance Maturity calculator UI here
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class BankEmiScreen extends StatefulWidget {
  const BankEmiScreen({super.key});

  @override
  State<BankEmiScreen> createState() => _BankEmiScreenState();
}

class _BankEmiScreenState extends State<BankEmiScreen> {
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
                "EMI Calculator",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Add your EMI calculator UI here
            ],
          ),
        ),
      ),
    );
  }
}
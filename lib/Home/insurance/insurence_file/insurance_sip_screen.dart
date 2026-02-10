import 'package:flutter/material.dart';

class InsuranceSipScreen extends StatefulWidget {
  const InsuranceSipScreen({super.key});

  @override
  State<InsuranceSipScreen> createState() => _InsuranceSipScreenState();
}

class _InsuranceSipScreenState extends State<InsuranceSipScreen> {
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
                "Insurance SIP Calculator",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Add your Insurance SIP calculator UI here
            ],
          ),
        ),
      ),
    );
  }
}
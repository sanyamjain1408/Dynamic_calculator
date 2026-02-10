import 'package:flutter/material.dart';

class BankRdScreen extends StatefulWidget {
  const BankRdScreen({super.key});

  @override
  State<BankRdScreen> createState() => _BankRdScreenState();
} 

class _BankRdScreenState extends State<BankRdScreen> {
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
                "RD Calculator",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Add your RD calculator UI here
            ],
          ),
        ),
      ),
    );
  }
}
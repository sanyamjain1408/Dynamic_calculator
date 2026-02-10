import 'package:flutter/material.dart';

class BankFdScreen extends StatefulWidget {
  const BankFdScreen({super.key});

  @override
  State<BankFdScreen> createState() => _BankFdScreenState();
} 

class _BankFdScreenState extends State<BankFdScreen> {
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
                "FD Calculator",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Add your FD calculator UI here
            ],
          ),
        ),
      ),
    );
  }
}
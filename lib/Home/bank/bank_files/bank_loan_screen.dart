import 'package:flutter/material.dart';

class BankLoanScreen extends StatefulWidget {
  const BankLoanScreen({super.key});

  @override
  State<BankLoanScreen> createState() => _BankLoanScreenState();
} 


class _BankLoanScreenState extends State<BankLoanScreen> {
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
                "Loan Calculator",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Add your Loan calculator UI here
            ],
          ),
        ),
      ),
    );
  }
}
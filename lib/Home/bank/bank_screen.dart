import 'package:calculator/Home/bank/bank_files/bank_emi_screen.dart';
import 'package:calculator/Home/bank/bank_files/bank_fd_screen.dart';
import 'package:calculator/Home/bank/bank_files/bank_loan_screen.dart';
import 'package:calculator/Home/bank/bank_files/bank_rd_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
         return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
      
                /// Card 1: EMI Calculator
                buildCard(
                  context,
                  title: "EMI Calculator",
                  subtitle: "Calculate your monthly installments",
                  icon: Image.asset('assets/emi_logo.png'),
                  onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BankEmiScreen(),
                      ),
                   );
                  },
                ),
      
                const SizedBox(height: 16),
      
                /// Card 2: Loan Eligibility Calculator
                buildCard(
                  context,
                  title: "Loan Eligibility",
                  subtitle: "Check your loan eligibility amount",
                  icon: Image.asset('assets/loan_logo.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BankLoanScreen(),
                      ),
                    );
                  },
                ),
      
                const SizedBox(height: 16),
      
                /// Card 3: FD Calculator
                buildCard(
                  context,
                  title: "FD Calculator",
                  subtitle: "Calculate fixed deposit amounts",
                  icon: Image.asset('assets/fd_logo.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BankFdScreen(),
                      ),
                    );
                  },
                ),
      
                const SizedBox(height: 16),
      
                  /// Card 4: RD Calculator
                buildCard(
                  context,
                  title: "RD Calculator",
                  subtitle: "Calculate recurring deposit maturity",
                  icon: Image.asset('assets/rd_logo.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BankRdScreen(),
                      ),
                    );
                  },
                ),
      
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable Card Widget
  Widget buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE9ECFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                height: 32,
                width: 32,
                child: icon,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
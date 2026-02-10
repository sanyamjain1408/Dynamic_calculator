import 'package:calculator/Home/insurance/insurence_file/insurance_maturity_screen.dart';
import 'package:calculator/Home/insurance/insurence_file/insurance_sip_screen.dart';
import 'package:calculator/Home/insurance/insurence_file/insurance_term_screen.dart';
import 'package:calculator/Home/insurance/insurence_file/insurence_premium_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
} 

class _InsuranceScreenState extends State<InsuranceScreen> {
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
      
                /// Card 1: Premium Calculator
                buildCard(
                  context,
                  title: "Premium Calculator",
                  subtitle: "Calculate insurance premium amounts",
                  icon: Image.asset('assets/premium_logo.png'),
                  onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InsurencePremiumScreen(),
                      ),
                   );
                  },
                ),
      
                const SizedBox(height: 16),
      
                /// Card 2: Term Insurance
                buildCard(
                  context,
                  title: "Term Insurance",
                  subtitle: "Calculate term insurance coverage",
                  icon: Image.asset('assets/term_logo.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InsuranceTermScreen(),
                      ),
                    );
                  },
                ),
      
                const SizedBox(height: 16),
      
                /// Card 3: SIP Calculator
                buildCard(
                  context,
                  title: "SIP / ULIP Calculator",
                  subtitle: "Calculate SIP/ULIP returns",
                  icon: Image.asset('assets/sip_logo.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InsuranceSipScreen(),
                      ),
                    );
                  },
                ),
      
                const SizedBox(height: 16),
      
                  /// Card 4: Maturity Calculator
                buildCard(
                  context,
                  title: "Maturity Calculator",
                  subtitle: "Calculate policy maturity amounts",
                  icon: Image.asset('assets/maturity_logo.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InsuranceMaturityScreen(),
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
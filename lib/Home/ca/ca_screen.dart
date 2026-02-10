import 'package:calculator/Home/calculator/calculator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ca_files/ca_income_tax_screen.dart';
import 'ca_files/ca_hra_screen.dart';
import 'ca_files/ca_gst_screen.dart';
import 'ca_files/ca_tds_screen.dart';
import 'ca_files/ca_depreciation_screen.dart';

class CaScreen extends StatefulWidget {
  const CaScreen({super.key});

  @override
  State<CaScreen> createState() => _CaScreenState();
}

class _CaScreenState extends State<CaScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
         return false;},
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
      
                /// Card 1: Income Tax Calculator
                buildCard(
                  context,
                  title: "Income Tax Calculator",
                  subtitle: "Calculate your income tax liability",
                  icon: Image.asset('assets/incometax_logo.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CaIncomeTaxScreen(),
                      ),
                    );
                  },
                ),
      
                const SizedBox(height: 16),
      
                /// Card 2: HRA Calculator
                buildCard(
                  context,
                  title: "HRA Calculator",
                  subtitle: "Calculate House Rent Allowance",
                  icon: Image.asset('assets/hra_logo.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CaHraScreen(),
                      ),
                    );
                  },
                ),
      
                const SizedBox(height: 16),
      
                /// Card 3: GST Calculator
                buildCard(
                  context,
                  title: "GST Calculator",
                  subtitle: "GST inclusive & exclusive",
                  icon: Image.asset('assets/gst_logo.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CaGstScreen(),
                      ),
                    );
                  },
                ),
      
                const SizedBox(height: 16),
      
                  /// Card 4: TDS Calculator
                buildCard(
                  context,
                  title: "TDS Calculator",
                  subtitle: "Tax Deducted at Source",
                  icon: Image.asset('assets/tds_logo.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CaTdsScreen(),
                      ),
                    );
                  },
                ),
      
                const SizedBox(height: 16),
      
      
                  /// Card 5: Depreciation Calculator
                buildCard(
                  context,
                  title: "Depreciation Calculator",
                  subtitle: "Asset depreciation calculation",
                  icon: Image.asset('assets/depreciation_logo.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CaDepreciationScreen(),
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

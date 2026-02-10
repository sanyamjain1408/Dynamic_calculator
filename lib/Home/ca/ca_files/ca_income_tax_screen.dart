import 'package:flutter/material.dart';

class CaIncomeTaxScreen extends StatefulWidget {
  const CaIncomeTaxScreen({super.key});

  @override
  State<CaIncomeTaxScreen> createState() => _CaIncomeTaxScreenState();
}

class _CaIncomeTaxScreenState extends State<CaIncomeTaxScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('CA Income Tax Screen')),
    );
  }
}
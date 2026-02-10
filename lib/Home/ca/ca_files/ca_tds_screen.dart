import 'package:flutter/material.dart';

class CaTdsScreen extends StatefulWidget {
  const CaTdsScreen({super.key});

  @override
  State<CaTdsScreen> createState() => _CaTdsScreenState();
}

class _CaTdsScreenState extends State<CaTdsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('CA TDS Calculator Screen')),
    );
  }
}
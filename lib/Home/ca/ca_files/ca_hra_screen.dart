import 'package:flutter/material.dart';

class CaHraScreen extends StatefulWidget {
  const CaHraScreen({super.key});

  @override
  State<CaHraScreen> createState() => _CaHraScreenState();
}

class _CaHraScreenState extends State<CaHraScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('CA HRA Calculator Screen')),
    );
  }
}
import 'package:flutter/material.dart';

class PropertyElectricityScreen extends StatefulWidget {
  const PropertyElectricityScreen({super.key});

  @override
  State<PropertyElectricityScreen> createState() => _PropertyElectricityScreenState();
}

class _PropertyElectricityScreenState extends State<PropertyElectricityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Electricity Bill",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(
        child: Text("Electricity Bill"),
      ),
    );
  }
}
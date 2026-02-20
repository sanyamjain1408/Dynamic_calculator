import 'package:flutter/material.dart';

class PropertyLandUnitScreen extends StatefulWidget {
  const PropertyLandUnitScreen({super.key});

  @override
  State<PropertyLandUnitScreen> createState() => _PropertyLandUnitScreenState();
}

class _PropertyLandUnitScreenState extends State<PropertyLandUnitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Land Unit",
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
        child: Text("Land Unit"),
      ),
    );
  }
}
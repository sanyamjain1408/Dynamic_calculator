import 'package:flutter/material.dart';

class PropertyPaintcostScreen extends StatefulWidget {
  const PropertyPaintcostScreen({super.key});

  @override
  State<PropertyPaintcostScreen> createState() => _PropertyPaintcostScreenState();
}

class _PropertyPaintcostScreenState extends State<PropertyPaintcostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Paint Cost",
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
        child: Text("Paint Cost"),
      ),
    );
  }
}
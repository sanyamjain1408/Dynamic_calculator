import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        backgroundColor: Colors.grey.shade200,
      ),
      body: const Center(
        child: Text(
          "No history available",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
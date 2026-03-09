import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatelessWidget {
  final Map data;

  const HistoryDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculation Detail")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Calculator
                  const Text("Calculator"),
                  Text(
                    data["calculator_name"]?.toString() ?? "",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  /// Amount
                  const Text("Amount"),
                  Text(
                    "₹ ${data["amount"]}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  /// GST Rate
                  const Text("GST Rate"),
                  Text("${data["gst_rate"]}%"),

                  const SizedBox(height: 15),

                  /// GST Amount
                  const Text("GST Amount"),
                  Text("₹ ${data["gst_amount"]}"),

                  const SizedBox(height: 15),

                  /// Total Amount
                  const Text("Total Amount"),
                  Text(
                    "₹ ${data["total_amount"]}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  /// Date
                  const Text("Date"),
                  Text(data["created_at"].toString().substring(0, 10)),
                ],
              ),
            ),

            const Spacer(),

            /// Bottom Actions
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.edit),
                  Icon(Icons.delete),
                  Icon(Icons.download),
                  Icon(Icons.share),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

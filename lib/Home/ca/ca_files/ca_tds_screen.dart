import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CaTdsScreen extends StatefulWidget {
  const CaTdsScreen({super.key});

  @override
  State<CaTdsScreen> createState() => _CaTdsScreenState();
}

class _CaTdsScreenState extends State<CaTdsScreen> {

  final TextEditingController _amountController = TextEditingController();

  double selectedTdsRate = 1; // default 1%
  double netAmount = 0;
  double tdsAmount = 0;
  double totalAmount = 0;

  bool isLoading = false;

  final String baseUrl = "http://192.168.1.2:8000";

Future<void> calculateTDS() async {
    FocusScope.of(context).unfocus();

    double amount = double.tryParse(_amountController.text) ?? 0;

    if (amount <= 0) return;

    setState(() => isLoading = true);

    final url = "$baseUrl/ca_app/tds/calculate/";

    final requestBody = {
      "calculator_type": "tds calculator",
      "amount": amount,
      "tds_rate": selectedTdsRate,
    };

    print("------------------------- POST REQUEST ---------------------------------");
    print("URL: $url");
    print("BODY: ${jsonEncode(requestBody)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

       print("----------------------------- POST RESPONSE -----------------------------");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");


      // Calculate TDS
      double tds = (amount * selectedTdsRate) / 100;
      double net = amount - tds;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final result = data["result"];
        
        setState(() {
          tdsAmount = (result["tds_amount"] ?? 0).toDouble();
          netAmount = (result["net_amount"] ?? 0).toDouble();
          totalAmount = (result["total_amount"] ?? 0).toDouble();
        });
      } else {
        print("Post Error: ${response.body}");
      }
    } catch (e) {
      print("Connection failed: $e");
    } finally {
      setState(() => isLoading = false);
    }
  } 

   @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TDS Calculator", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade100,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// INPUT CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Amount",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Amount",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey,),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<double>(
                      value: selectedTdsRate,
                      decoration: const InputDecoration(
                        labelText: "TDS Rate (%)",
                        border: OutlineInputBorder(),
                      ),
                      items: [1, 2, 5, 10]
                          .map((rate) => DropdownMenuItem(
                                value: rate.toDouble(),
                                child: Text("$rate%"),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTdsRate = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: calculateTDS,
                        child:  isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                          "Calculate Tax",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// SUMMARY CARD
              if (netAmount > 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Tax Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Net Amount :"),
                          Text("₹${netAmount.toStringAsFixed(2)}"),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("TDS (${selectedTdsRate}%):"),
                          Text(
                            "₹${tdsAmount.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),

                      const Divider(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Amount :",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "₹${totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}

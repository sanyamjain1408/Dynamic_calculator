import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CaGstScreen extends StatefulWidget {
  const CaGstScreen({super.key});

  @override
  State<CaGstScreen> createState() => _CaGstScreenState();
}

class _CaGstScreenState extends State<CaGstScreen> {
  final TextEditingController _amountController = TextEditingController();

  
  String selectedCalculationType = "Exclusive";
  String selectedGstType = "GST";
  double selectedGstRate = 18;

  double netAmount = 0;
  double taxAmount = 0;
  double totalAmount = 0;

  double igst = 0;
  double cgst = 0;
  double sgst = 0;

  bool isLoading = false;

  ///  CHANGE THIS IP IF NEEDED
  final String baseUrl = "http://192.168.1.2:8000";

  Future<void> calculateGST() async {
    FocusScope.of(context).unfocus();

    double amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    setState(() {
      isLoading = true;
    });

    final url = "$baseUrl/ca_app/gst/calculate/";

    final requestBody = {
      "calculator_type": "gst calculator",
      "amount": amount,
      "gst_rate": selectedGstRate,
      "calculation_type": selectedCalculationType,
      "gst_type": selectedGstType,
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final result = data["result"];

        setState(() {
          netAmount = (result["net_amount"] ?? 0).toDouble();
          taxAmount = (result["gst_amount"] ?? 0).toDouble();
          totalAmount = (result["total_amount"] ?? 0).toDouble();
          igst = (result["igst"] ?? 0).toDouble();
          cgst = (result["cgst"] ?? 0).toDouble();
          sgst = (result["sgst"] ?? 0).toDouble();
        });
      } else {
        print("POST Error: ${response.body}");
      }
    } catch (e) {
      print("Connection Error: $e");
    }

    setState(() {
      isLoading = false;
    });
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
          "GST Calculator",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
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
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                        hintText: "Enter Amount",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// GST RATE
                    DropdownButtonFormField<double>(
                      value: selectedGstRate,
                      decoration: const InputDecoration(
                        labelText: "GST Rate (%)",
                        border: OutlineInputBorder(),
                      ),
                      items: [5, 12, 18, 28]
                          .map((rate) => DropdownMenuItem(
                                value: rate.toDouble(),
                                child: Text("$rate%"),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGstRate = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    /// CALCULATION TYPE
                    DropdownButtonFormField<String>(
                      value: selectedCalculationType,
                      decoration: const InputDecoration(
                        labelText: "Calculation Type",
                        border: OutlineInputBorder(),
                      ),
                      items: ["Exclusive", "Inclusive"]
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCalculationType = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    /// GST TYPE
                    DropdownButtonFormField<String>(
                      value: selectedGstType,
                      decoration: const InputDecoration(
                        labelText: "GST Type",
                        border: OutlineInputBorder(),
                      ),
                      items: ["GST", "IGST", "CGST/SGST"]
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGstType = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: calculateGST,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Calculate Tax",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
              if (totalAmount > 0)
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
                          Text("Net Amount: "),
                          Text("₹${netAmount.toStringAsFixed(2)}",
                           style: const TextStyle(fontWeight: FontWeight.bold),
                           ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tax Amount: "),
                          Text("₹${taxAmount.toStringAsFixed(2)}",
                           style: const TextStyle(fontWeight: FontWeight.bold),
                           ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("IGST: "),
                          Text("₹${igst.toStringAsFixed(2)}",
                           style: const TextStyle(fontWeight: FontWeight.bold),
                           ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("CGST: "),
                          Text("₹${cgst.toStringAsFixed(2)}",
                           style: const TextStyle(fontWeight: FontWeight.bold),
                           ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("SGST: "),
                          Text("₹${sgst.toStringAsFixed(2)}",
                           style: const TextStyle(fontWeight: FontWeight.bold),
                           ),
                        ],
                      ),

                       const Divider(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Amount: "),
                          Text("₹${totalAmount.toStringAsFixed(2)}",
                           style: const TextStyle(fontWeight: FontWeight.bold),
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

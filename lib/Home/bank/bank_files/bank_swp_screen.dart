import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:calculator/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankSwpScreen extends StatefulWidget {
  const BankSwpScreen({super.key});

  @override
  State<BankSwpScreen> createState() => _BankSwpScreenState();
}

class _BankSwpScreenState extends State<BankSwpScreen> {
  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _withdrawController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  double investedAmount = 0;
  double monthlyWithdrawal = 0;
  double totalWithdrawn = 0;
  double totalAmount = 0;

  bool isLoading = false;

  Future<void> calculateSWP() async {
    FocusScope.of(context).unfocus();

    double investment = double.tryParse(_investmentController.text.replaceAll(',', '')) ?? 0;

    double withdrawal = double.tryParse(_withdrawController.text) ?? 0;

    double rate = double.tryParse(_rateController.text) ?? 0;

    double years = double.tryParse(_timeController.text) ?? 0;

    if (investment <= 0 || withdrawal <= 0 || years <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter Valid Values")),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = "${ApiConfig.baseUrl}/ca_app/banking-swp/calculate/";

    final requestBody = {
      "calculator_type": "swp calculator",
      "invested_amount": investment,
      "monthly_withdrawal": withdrawal,
      "interest_rate": rate,
      "time_period_years": years
    };

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    print("------------ POST REQUEST ------------");
    print("URL: $url");
    print("BODY: ${jsonEncode(requestBody)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": "Token $token"},
        body: jsonEncode(requestBody),
      );

      print("------------ POST RESPONSE ------------");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final result = data["result"] ?? {};

        if (!mounted) return;

        setState(() {
          investedAmount = (result["invested_amount"] ?? 0).toDouble();
          monthlyWithdrawal = (result["monthly_withdrawal"] ?? 0).toDouble();
          totalWithdrawn = (result["total_withdrawn"] ?? 0).toDouble();
          totalAmount = (result["total_amount"] ?? 0).toDouble();
        });
      } else {
        final error = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error["error"] ?? "Calculation Failed")),
        );
      }
    } catch (e) {
      print("Connection Error: $e");
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _investmentController.dispose();
    _withdrawController.dispose();
    _rateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Widget buildRow(String title, double value, {bool isFinal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: isFinal ? FontWeight.bold : FontWeight.normal)),
          Text(
            "₹${value.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight: isFinal ? FontWeight.bold : FontWeight.normal,
              color: isFinal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SWP Calculator",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                    const Text("Total Investment", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _investmentController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        IndianNumberFormatter(),
                      ],
                      decoration: const InputDecoration(
                        hintText: "Enter Total Investment",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Withdrawal (per month)", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _withdrawController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Monthly Withdrawal",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Return Rate (% per year)", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _rateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Annual Return Rate",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Time Period (Years)", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _timeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Time Period (Years)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: calculateSWP,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Calculate SWP",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// RESULT CARD
              if (investedAmount > 0)
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
                        "SWP Summary",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const SizedBox(height: 15),
                      buildRow("Invested Amount :", investedAmount),
                      buildRow("Withdrawal (P.M) :", monthlyWithdrawal),
                      buildRow("Total Withdrawn :", totalWithdrawn),
                      const Divider(height: 25),
                      buildRow("Total Amount :", totalAmount, isFinal: true),
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

class IndianNumberFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##,###');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    String newText = newValue.text.replaceAll(',', '');

    final number = int.parse(newText);

    final formatted = _formatter.format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

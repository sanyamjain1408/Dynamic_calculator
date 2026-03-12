import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calculator/config/app_config.dart';

class InsurenceXirrScreen extends StatefulWidget {
  const InsurenceXirrScreen({super.key});

  @override
  State<InsurenceXirrScreen> createState() => _InsurenceXirrScreenState();
}

class _InsurenceXirrScreenState extends State<InsurenceXirrScreen> {
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  final NumberFormat formatter = NumberFormat('#,##,###');

  DateTime? startDate;
  DateTime? endDate;
  DateTime? maturityDate;

  final TextEditingController investmentController = TextEditingController();
  final TextEditingController totalInvestmentController = TextEditingController();
  final TextEditingController maturityAmountController = TextEditingController();

  String selectedFrequency = "Monthly";

  double? xirrResult;

  bool isLoading = false;

  /// DATE PICKER
  Future<void> pickDate(Function(DateTime) onSelected) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onSelected(picked);
    }
  }

  /// FORMAT NUMBER
  void formatNumber(TextEditingController controller, String value) {
    String clean = value.replaceAll(',', '');

    if (clean.isEmpty) return;

    final number = int.tryParse(clean);

    if (number == null) return;

    final newText = formatter.format(number);

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  /// TOTAL INVESTMENT
  void updateTotalInvestment() {
    if (startDate == null || endDate == null || investmentController.text.isEmpty) {
      totalInvestmentController.clear();
      return;
    }

    double investment = double.tryParse(investmentController.text.replaceAll(',', '')) ?? 0;

    int installments = 0;

    switch (selectedFrequency) {
      case "One Time":
        totalInvestmentController.text = formatter.format(investment.toInt());
        return;

      case "Monthly":
        installments = ((endDate!.year - startDate!.year) * 12) + (endDate!.month - startDate!.month) + 1;
        break;

      case "Quarterly":
        installments = (((endDate!.year - startDate!.year) * 12) + (endDate!.month - startDate!.month)) ~/ 3 + 1;
        break;

      case "Half Yearly":
        installments = (((endDate!.year - startDate!.year) * 12) + (endDate!.month - startDate!.month)) ~/ 6 + 1;
        break;

      case "Yearly":
        installments = (endDate!.year - startDate!.year) + 1;
        break;

      case "14 Days":
        int days = endDate!.difference(startDate!).inDays;
        installments = (days ~/ 14) + 1;
        break;
    }

    double totalInvestment = installments * investment;

    totalInvestmentController.text = formatter.format(totalInvestment.toInt());
  }

  /// CALCULATE (API CALL)
  Future<void> calculate() async {
    if (startDate == null ||
        endDate == null ||
        maturityDate == null ||
        investmentController.text.isEmpty ||
        maturityAmountController.text.isEmpty) {
      return;
    }

    final url = "${ApiConfig.baseUrl}/ca_app/xirr/calculate/";

    final requestBody = {
      "start_date": startDate!.toIso8601String(),
      "end_date": endDate!.toIso8601String(),
      "maturity_date": maturityDate!.toIso8601String(),
      "investment": investmentController.text.replaceAll(',', ''),
      "maturity_amount": maturityAmountController.text.replaceAll(',', ''),
      "frequency": selectedFrequency
    };

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    setState(() {
      isLoading = true;
    });

    print("------------ POST REQUEST ------------");
    print("URL: $url");
    print("BODY: ${jsonEncode(requestBody)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", 
        "Authorization": "Token $token"},
        body: jsonEncode(requestBody),
      );


      print("------------ POST RESPONSE ------------");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");


      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          xirrResult = (data["total_amount"] ?? 0).toDouble();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Calculation failed")),
        );
      }
    } catch (e) {
      print("Connection Error: $e");
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server connection failed")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  /// UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          "XIRR Calculator",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// INPUT CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  buildDateField("Start Date", startDate, (d) {
                    setState(() => startDate = d);
                    updateTotalInvestment();
                  }),
                  const SizedBox(height: 12),
                  buildTextField("Investment", investmentController),
                  const SizedBox(height: 12),
                  buildDateField("End Date", endDate, (d) {
                    setState(() => endDate = d);
                    updateTotalInvestment();
                  }),
                  const SizedBox(height: 12),
                  buildDateField("Maturity Date", maturityDate, (d) {
                    setState(() => maturityDate = d);
                  }),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedFrequency,
                    items: const ["One Time", "14 Days", "Monthly", "Quarterly", "Half Yearly", "Yearly"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      setState(() => selectedFrequency = val!);
                      updateTotalInvestment();
                    },
                    decoration: inputDecoration("Time Frequency"),
                  ),
                  const SizedBox(height: 12),
                  buildTextField("Total Investment", totalInvestmentController, readOnly: true),
                  const SizedBox(height: 12),
                  buildTextField("Maturity Amount", maturityAmountController),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: isLoading ? null : calculate,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Calculate XIRR",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// RESULT CARD
            if (xirrResult != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Extended Internal Rate Of Return",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${xirrResult!.toStringAsFixed(2)}%",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: xirrResult! < 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// UI HELPERS
  Widget buildDateField(String label, DateTime? date, Function(DateTime) onSelect) {
    return InkWell(
      onTap: () => pickDate(onSelect),
      child: InputDecorator(
        decoration: inputDecoration(label),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(date == null ? "" : dateFormat.format(date)), const Icon(Icons.calendar_today)],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      decoration: inputDecoration(label),
      onChanged: (value) {
        formatNumber(controller, value);
        updateTotalInvestment();
      },
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

import 'package:calculator/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PropertyLandUnitScreen extends StatefulWidget {
  const PropertyLandUnitScreen({super.key});

  @override
  State<PropertyLandUnitScreen> createState() => _PropertyLandUnitScreenState();
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

class _PropertyLandUnitScreenState extends State<PropertyLandUnitScreen> {
  final TextEditingController areaController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  String selectedUnit = "Square Meter";
  String selectedCostType = "Total Cost";

  double totalAmount = 0;

  bool isLoading = false;
  final NumberFormat indianFormat = NumberFormat('#,##,###');

  Map<String, dynamic> resultData = {};

  List<String> units = [
    "Square Meter",
    "Square Kilometer",
    "Square Feet",
    "Square Miles",
    "Square Yards",
    "Are",
    "Decare",
    "Hectare",
    "Acre",
    "Soccer Field"
  ];

  List<String> costTypes = ["Total Cost", "Per Unit Cost"];

  Future<void> calculateLandUnit() async {
    FocusScope.of(context).unfocus();

    double area = double.tryParse(areaController.text.replaceAll(",", "")) ?? 0;
    double cost = double.tryParse(costController.text.replaceAll(",", "")) ?? 0;

    if (area <= 0 || cost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter Valid Values")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = "${ApiConfig.baseUrl}/ca_app/land-unit/calculate/";

    final requestBody = {"area": area, "unit": selectedUnit, "cost": cost, "cost_type": selectedCostType};

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

        if (!mounted) return;

        setState(() {
          resultData = data["result"] ?? {};
          totalAmount = (resultData["total_amount"] ?? 0).toDouble();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Calculation failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server connection failed")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget dropdown(String value, List<String> list, Function(String?) onChange) {
    return DropdownButton<String>(
      value: value,
      underline: const SizedBox(),
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 3,
      dropdownColor: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
      alignment: AlignmentDirectional.centerEnd,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      items: list
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onChange,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Land Unit Converter",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// AREA INPUT
                    ///

                    const Text("Enter Area", style: TextStyle(fontWeight: FontWeight.bold)),

                    const SizedBox(height: 8),

                    TextField(
                      controller: areaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [IndianNumberFormatter()],
                      decoration: InputDecoration(
                        labelText: "Enter Area",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: dropdown(selectedUnit, units, (val) {
                            setState(() {
                              selectedUnit = val!;
                            });
                          }),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// COST INPUT
                    ///
                    const Text(
                      "Enter Cost", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold)),

                    const SizedBox(height: 8),

                    TextField(
                      controller: costController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [IndianNumberFormatter()],
                      decoration: InputDecoration(
                        labelText: "Enter Cost",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: dropdown(selectedCostType, costTypes, (val) {
                            setState(() {
                              selectedCostType = val!;
                            });
                          }),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : calculateLandUnit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Calculate Unit",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// RESULT
              /// RESULT
              if (resultData.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Land Unit Summary",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const Divider(),
                      summaryRow("Square Meter", indianFormat.format(resultData["square_meter"] ?? 0)),
                      summaryRow("Square Kilometer", indianFormat.format(resultData["square_kilometer"] ?? 0)),
                      summaryRow("Square Feet", indianFormat.format(resultData["square_feet"] ?? 0)),
                      summaryRow("Square Miles", indianFormat.format(resultData["square_miles"] ?? 0)),
                      summaryRow("Square Yards", indianFormat.format(resultData["square_yards"] ?? 0)),
                      summaryRow("Are", indianFormat.format(resultData["are"] ?? 0)),
                      summaryRow("Decare", indianFormat.format(resultData["decare"] ?? 0)),
                      summaryRow("Hectare", indianFormat.format(resultData["hectare"] ?? 0)),
                      summaryRow("Acre", indianFormat.format(resultData["acre"] ?? 0)),
                      summaryRow("Soccer Field", indianFormat.format(resultData["soccer_field"] ?? 0)),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget summaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            "₹$value",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

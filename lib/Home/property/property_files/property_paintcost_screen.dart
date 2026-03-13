import 'dart:convert';
import 'package:calculator/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyPaintcostScreen extends StatefulWidget {
  const PropertyPaintcostScreen({super.key});

  @override
  State<PropertyPaintcostScreen> createState() => _PropertyPaintcostScreenState();
}

/// Indian comma formatter
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

class _PropertyPaintcostScreenState extends State<PropertyPaintcostScreen> {
  final TextEditingController areaController = TextEditingController();
  final TextEditingController efficiencyController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  String selectedAreaType = "Square Feet";
  String efficiencyUnit = "Liter";
  String costUnit = "Liter";

  bool isLoading = false;

  final NumberFormat indianFormat = NumberFormat('#,##,###');

  double volume = 0;
  double totalCost = 0;

  List<String> areaTypes = [
    "Square Meter",
    "Square Feet",
    "Square Kilometer",
    "Square Yards",
    "Are",
    "Decare",
    "Hectare",
    "Acre",
    "Soccer Field"
  ];

  List<String> unitTypes = ["Liter", "20 Liter"];

  Future<void> calculatePaintCost() async {
     FocusScope.of(context).unfocus();

    double area = double.tryParse(areaController.text.replaceAll(',', '')) ?? 0;
    double efficiency = double.tryParse(efficiencyController.text.replaceAll(',', '')) ?? 0;
    double cost = double.tryParse(costController.text.replaceAll(',', '')) ?? 0;

    if (area <= 0 || efficiency <= 0 || cost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid values")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = "${ApiConfig.baseUrl}/ca_app/paint-cost/calculate/";

    final requestBody = {
      "total_area": area,
      "area_type": selectedAreaType,
      "paint_efficiency": efficiency,
      "efficiency_type": efficiencyUnit,
      "cost_per_unit": cost,
      "unit_type": costUnit
    };

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

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
          volume = (data["paint_needed"] ?? 0).toDouble();
          totalCost = (data["total_amount"] ?? 0).toDouble();
        });
      } else {
        final error = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Calculation failed")),
        );
      }
    } catch (e) {
      print("Connection Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server connection failed")),
      );
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    areaController.dispose();
    efficiencyController.dispose();
    costController.dispose();
    super.dispose();
  }

  Widget summaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            "$value",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          "Paint Cost Calculator",
          style: TextStyle(
            fontWeight: FontWeight.bold,
             color: Colors.blue
             ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

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
                    /// TOTAL AREA
                    ///
                   const Text(
                    "Total Area",
                     style: TextStyle(
                      fontWeight: FontWeight.bold)
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: areaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        IndianNumberFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: "Enter Total Area",
                        suffixIconConstraints: const BoxConstraints(minWidth: 0),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: dropdown(selectedAreaType, areaTypes, (val) {
                            setState(() {
                              selectedAreaType = val!;
                            });
                          }),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Paint Efficiency",
                       style: TextStyle(
                        fontWeight: FontWeight.bold)
                        ),

                    const SizedBox(height: 8),

                    /// PAINT EFFICIENCY
                    TextField(
                      controller: efficiencyController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        IndianNumberFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: "Enter Paint Efficiency",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: dropdown(efficiencyUnit, unitTypes, (val) {
                            setState(() {
                              efficiencyUnit = val!;
                            });
                          }),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Cost per Unit", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold)),

                    const SizedBox(height: 8),

                    /// COST PER UNIT
                    TextField(
                      controller: costController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        IndianNumberFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: "Enter Cost per Unit",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: dropdown(costUnit, unitTypes, (val) {
                            setState(() {
                              costUnit = val!;
                            });
                          }),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: isLoading ? null : calculatePaintCost,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Calculate Cost",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // result card
              if (volume > 0 || totalCost > 0)
                Container(
                  width: double.infinity,
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
                        "Paint Cost Summary",
                        style: TextStyle(
                          color: Colors.blue,
                           fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      summaryRow("Volume of paint needed :", "${volume.toStringAsFixed(2)}"),
                      summaryRow("Total cost :", "₹ ${indianFormat.format(totalCost)}"),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

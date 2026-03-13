import 'dart:convert';
import 'package:calculator/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyElectricityScreen extends StatefulWidget {
  const PropertyElectricityScreen({super.key});

  @override
  State<PropertyElectricityScreen> createState() => _PropertyElectricityScreenState();
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


class _PropertyElectricityScreenState extends State<PropertyElectricityScreen> {
  final TextEditingController powerController = TextEditingController();
  final TextEditingController energyController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  String powerUnit = "Watts";
  String energyUnit = "Watts";
  String timeUnit = "Day";

  double powerConsumed = 0;
  double totalCost = 0;

  bool isLoading = false;

  final NumberFormat indianFormat = NumberFormat('#,##,###');

  List<String> powerType = ["Watts", "KW",  "MW", "GW"];

  List<String> timeType = ["Hrs", "Day", "Month", "Year"];

  Future<void> calculateElectricity() async {
    FocusScope.of(context).unfocus();

    double power = double.tryParse(powerController.text.replaceAll(',', '')) ?? 0;
    double energy = double.tryParse(energyController.text.replaceAll(',', '')) ?? 0;
    double time = double.tryParse(timeController.text.replaceAll(',', '')) ?? 0;

    if (power <= 0 || energy <= 0 || time <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid values")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = "${ApiConfig.baseUrl}/ca_app/electricity/calculate/";

    final requestBody = {
      "power_consumption": power,
      "power_unit": powerUnit,
      "energy_price": energy,
      "energy_unit": energyUnit,
      "usage_time": time,
      "time_unit": timeUnit
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

        if (!mounted) return;

        setState(() {
          powerConsumed = (data["power_consumed"] ?? 0).toDouble();
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
    powerController.dispose();
    energyController.dispose();
    timeController.dispose();
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
          "Electricity Bill Calculator",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// POWER CONSUMPTION
                    const Text(
                      "Power Consumption",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: powerController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        IndianNumberFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: "Enter Power Consumption",
                        suffixIconConstraints: const BoxConstraints(minWidth: 0),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: dropdown(powerUnit, powerType, (val) {
                            setState(() {
                              powerUnit = val!;
                            });
                          }),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Energy Price", style: TextStyle(fontWeight: FontWeight.bold)),

                    const SizedBox(height: 8),

                    TextField(
                      controller: energyController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        IndianNumberFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: "Enter Energy Price",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: dropdown(energyUnit, powerType, (val) {
                            setState(() {
                              energyUnit = val!;
                            });
                          }),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Usage Time", style: TextStyle(fontWeight: FontWeight.bold)),

                    const SizedBox(height: 8),

                    TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        IndianNumberFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: "Udage Time",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: dropdown(timeUnit, timeType, (val) {
                            setState(() {
                              timeUnit = val!;
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
                        onPressed: isLoading ? null : calculateElectricity,
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

              /// RESULT CARD
              if (powerConsumed > 0 || totalCost > 0)
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
                        "Electricity Cost Summary",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      summaryRow("Power Consumed :", indianFormat.format(powerConsumed)),
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

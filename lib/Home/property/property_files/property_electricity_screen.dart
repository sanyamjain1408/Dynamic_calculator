import 'dart:convert';
import 'package:calculator/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PropertyElectricityScreen extends StatefulWidget {
  const PropertyElectricityScreen({super.key});

  @override
  State<PropertyElectricityScreen> createState() => _PropertyElectricityScreenState();
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

  List<String> powerType = ["Watts", "KW",  "MW", "GW"];

  List<String> timeType = ["Hrs", "Day", "Month", "Year"];

  Future<void> calculateElectricity() async {
    FocusScope.of(context).unfocus();

    double power = double.tryParse(powerController.text) ?? 0;
    double energy = double.tryParse(energyController.text) ?? 0;
    double time = double.tryParse(timeController.text) ?? 0;

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
      "power_consumption": powerController.text,
      "power_unit": powerUnit,
      "energy_price": energyController.text,
      "energy_unit": energyUnit,
      "usage_time": timeController.text,
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
    powerConsumed.toDouble();
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
                      decoration: InputDecoration(
                        labelText: "Enter Energy Price",
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

                    const Text("Usage Time", style: TextStyle(fontWeight: FontWeight.bold)),

                    const SizedBox(height: 8),

                    TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
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
                      summaryRow("Volume of paint needed :", "${powerConsumed.toStringAsFixed(2)}"),
                      summaryRow("Total cost :", "${totalCost.toStringAsFixed(0)}"),
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

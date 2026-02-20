import 'package:flutter/material.dart';

class CaIncomeTaxScreen extends StatefulWidget {
  const CaIncomeTaxScreen({super.key});

  @override
  State<CaIncomeTaxScreen> createState() => _CaIncomeTaxScreenState();
}

class _CaIncomeTaxScreenState extends State<CaIncomeTaxScreen> {

  final TextEditingController incomeController = TextEditingController();

  String selectedRegime = "new"; // default new regime

  double taxableIncome = 0;
  double incomeTax = 0;
  double cess = 0;
  double totalTax = 0;

  bool showResult = false;

  // 🔥 TAX CALCULATION FUNCTION
  void calculateTax() {
    FocusScope.of(context).unfocus(); // hide keyboard
    double income = double.tryParse(incomeController.text) ?? 0;
    taxableIncome = income;

    if (selectedRegime == "new") {
      // Simple New Regime Slab Example
      if (income <= 300000) {
        incomeTax = 0;
      } else if (income <= 600000) {
        incomeTax = (income - 300000) * 0.05;
      } else if (income <= 900000) {
        incomeTax = 15000 + (income - 600000) * 0.10;
      } else {
        incomeTax = 45000 + (income - 900000) * 0.15;
      }
    } else {
      // Simple Old Regime Slab Example
      if (income <= 250000) {
        incomeTax = 0;
      } else if (income <= 500000) {
        incomeTax = (income - 250000) * 0.05;
      } else if (income <= 1000000) {
        incomeTax = 12500 + (income - 500000) * 0.20;
      } else {
        incomeTax = 112500 + (income - 1000000) * 0.30;
      }
    }

    cess = incomeTax * 0.04;
    totalTax = incomeTax + cess;

    setState(() {
      showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Income Tax Calculator", style: TextStyle(color: Colors.blue)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
        
              /// 🔹 INPUT CARD
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
                      "Annual Income (₹)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
        
                    const SizedBox(height: 8),
        
                    TextField(
                      controller: incomeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Annual Income",
                        border: OutlineInputBorder(),
                      ),
                    ),
        
                    const SizedBox(height: 20),
        
                    const Text(
                      "Tax Regime",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
        
                    Row(
                      children: [
                        Radio(
                          value: "new",
                          groupValue: selectedRegime,
                          onChanged: (value) {
                            setState(() {
                              selectedRegime = value!;
                            });
                          },
                        ),
                        const Text("New Regime"),
        
                        Radio(
                          value: "old",
                          groupValue: selectedRegime,
                          onChanged: (value) {
                            setState(() {
                              selectedRegime = value!;
                            });
                          },
                        ),
                        const Text("Old Regime"),
                      ],
                    ),
        
                    const SizedBox(height: 20),
        
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: calculateTax,
                        child: const Text("Calculate Tax", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
        
              const SizedBox(height: 20),
        
              /// 🔹 RESULT CARD
              if (showResult)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
        
                      const Text(
                        "Tax Summary",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
        
                      const SizedBox(height: 10),
        
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Taxable Income:"),
                          Text("₹${taxableIncome.toStringAsFixed(0)}"),
                        ],
                      ),
        
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Income Tax:"),
                          Text("₹${incomeTax.toStringAsFixed(2)}"),
                        ],
                      ),
        
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Health & Education Cess (4%):"),
                          Text("₹${cess.toStringAsFixed(2)}"),
                        ],
                      ),
        
                      const Divider(),
        
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Tax Liability:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "₹${totalTax.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
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

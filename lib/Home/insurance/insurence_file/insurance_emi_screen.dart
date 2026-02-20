import 'package:flutter/material.dart';
import 'dart:math';

class InsuranceEmiScreen extends StatefulWidget {
  const InsuranceEmiScreen({super.key});

  @override
  State<InsuranceEmiScreen> createState() => _InsuranceEmiScreenState();
}

class _InsuranceEmiScreenState extends State<InsuranceEmiScreen> {

  
  final TextEditingController _loanController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  double emi = 0;
  double principalAmount = 0;
  double totalInterest = 0;
  double totalAmount = 0;

  void calculateEMI() {
    FocusScope.of(context).unfocus();

    double principal = double.tryParse(_loanController.text) ?? 0;
    double annualRate = double.tryParse(_rateController.text) ?? 0;
    double years = double.tryParse(_timeController.text) ?? 0;

    if (principal <= 0 || annualRate <= 0 || years <= 0) return;

    double monthlyRate = annualRate / 12 / 100;
    int months = (years * 12).toInt();

    double emiValue = (principal *
            monthlyRate *
            pow((1 + monthlyRate), months)) /
        (pow((1 + monthlyRate), months) - 1);

    double totalPayment = emiValue * months;
    double interest = totalPayment - principal;

    setState(() {
      principalAmount = principal;
      emi = emiValue;
      totalAmount = totalPayment;
      totalInterest = interest;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EMI Calculator",
          style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
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

                    const Text("Loan Amount",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _loanController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Loan Amount",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Rate of Interest (%)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _rateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Interest Rate",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Time Period (Years)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _timeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Time in Years",
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
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: calculateEMI,
                        child: const Text(
                          "Calculate EMI",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// SUMMARY CARD
              if (emi > 0)
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
                        "EMI Summary",
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
                          const Text("Monthly EMI :"),
                          Text(
                            "₹${emi.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Principal Amount :"),
                          Text("₹${principalAmount.toStringAsFixed(0)}"),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Interest :"),
                          Text(
                            "₹${totalInterest.toStringAsFixed(0)}",
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
                            "₹${totalAmount.toStringAsFixed(0)}",
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
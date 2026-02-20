import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';   // ✅ For input formatter
import 'package:intl/intl.dart';          // ✅ For comma formatting

class BankSipScreen extends StatefulWidget {
  const BankSipScreen({super.key});

  @override
  State<BankSipScreen> createState() => _BankSipScreenState();
}

class _BankSipScreenState extends State<BankSipScreen> {

  // ✅ Controllers for input fields
  final TextEditingController _monthlyController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // ✅ Result variables
  double investedAmount = 0;
  double estimatedReturn = 0;
  double totalAmount = 0;

  // ✅ Indian number format (10,00,000)
  final NumberFormat indianFormat = NumberFormat('#,##,###');

  //  SIP Calculation Function
  void calculateSIP() {

    // Hide keyboard
    FocusScope.of(context).unfocus();

    //  Remove comma before converting to double
    double monthlyInvestment =
        double.tryParse(_monthlyController.text.replaceAll(',', '')) ?? 0;

    double annualRate =
        double.tryParse(_rateController.text) ?? 0;

    double years =
        double.tryParse(_timeController.text) ?? 0;

    // If invalid input
    if (monthlyInvestment <= 0 || years <= 0) {
      setState(() {
        investedAmount = 0;
        estimatedReturn = 0;
        totalAmount = 0;
      });
      return;
    }

    // Total months
    int months = (years * 12).toInt();

    //  Convert annual rate to monthly rate
    double monthlyRate = (annualRate / 100) / 12;

    double maturityAmount;

    // If rate = 0
    if (monthlyRate == 0) {
      maturityAmount = monthlyInvestment * months;
    } else {
      //  Standard SIP formula
      maturityAmount = monthlyInvestment *
          ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
          (1 + monthlyRate);
    }

    double totalInvested = monthlyInvestment * months;
    double returns = maturityAmount - totalInvested;

    setState(() {
      investedAmount = totalInvested;
      estimatedReturn = returns;
      totalAmount = maturityAmount;
    });
  }

  //  UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SIP Calculator",
          style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold),
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
              //  INPUT CARD
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

                    // ===== Monthly Investment =====
                    const Text("Monthly Investment",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _monthlyController,
                      keyboardType: TextInputType.number,

                      //  This makes comma auto appear
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        IndianNumberFormatter(),
                      ],

                      decoration: const InputDecoration(
                        hintText: "Enter Monthly Amount",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===== Return Rate =====
                    const Text("Return Rate (% per year)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _rateController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: "Enter Annual Return Rate",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===== Time =====
                    const Text("Time Period (Years)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _timeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: "Enter Time in Years",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ===== Calculate Button =====
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: calculateSIP,
                        child: const Text(
                          "Calculate SIP",
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

              //  RESULT CARD
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
                        "SIP Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 15),

                      summaryRow("Invested Amount",
                          indianFormat.format(investedAmount)),

                      summaryRow("Est. Return",
                          indianFormat.format(estimatedReturn)),

                      const Divider(height: 25),

                      summaryRow("Total Amount",
                          indianFormat.format(totalAmount),
                          isBold: true),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  //  Reusable Summary Row
  Widget summaryRow(String title, String value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            "₹$value",
            style: TextStyle(
              fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

//  Custom Formatter for Indian Comma
class IndianNumberFormatter extends TextInputFormatter {

  final NumberFormat _formatter = NumberFormat('#,##,###');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {

    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove old commas
    String newText = newValue.text.replaceAll(',', '');

    final number = int.parse(newText);

    // Add Indian style comma
    final formatted = _formatter.format(number);

    return TextEditingValue(
      text: formatted,
      selection:
          TextSelection.collapsed(offset: formatted.length),
    );
  }
}

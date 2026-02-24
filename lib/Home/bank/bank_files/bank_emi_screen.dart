import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  
import 'package:intl/intl.dart';         
import 'dart:math';

class BankEmiScreen extends StatefulWidget {
  const BankEmiScreen({super.key});

  @override
  State<BankEmiScreen> createState() => _BankEmiScreenState();
}

class _BankEmiScreenState extends State<BankEmiScreen> {

  //  Controllers
  final TextEditingController _loanController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

 
  //  Result Variables
  double emi = 0;
  double principalAmount = 0;
  double totalInterest = 0;
  double totalAmount = 0;

  // ✅ Indian format for result (10,00,000)
  final NumberFormat indianFormat = NumberFormat('#,##,###');

  //  EMI Calculation Function
  void calculateEMI() {

    // Hide keyboard
    FocusScope.of(context).unfocus();

    //  Remove comma before parsing
    double principal =
        double.tryParse(_loanController.text.replaceAll(',', '')) ?? 0;

    double annualRate =
        double.tryParse(_rateController.text) ?? 0;

    double years =
        double.tryParse(_timeController.text) ?? 0;

    if (principal <= 0 || annualRate <= 0 || years <= 0) return;

    //  Convert annual rate to monthly rate
    double monthlyRate = annualRate / 12 / 100;

    // Total months
    int months = (years * 12).toInt();

    //  EMI Formula
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

  //  UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EMI Calculator",
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

                    // ===== Loan Amount =====
                    const Text("Loan Amount",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _loanController,
                      keyboardType: TextInputType.number,

                      //  Auto comma formatting
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        IndianNumberFormatter(),
                      ],

                      decoration: const InputDecoration(
                        hintText: "Enter Loan Amount",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey,),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===== Interest Rate =====
                    const Text("Rate of Interest (%)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _rateController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: "Enter Interest Rate",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey,),
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
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey,),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 25),

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
              //  RESULT CARD
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

                      summaryRow("Monthly EMI",
                          indianFormat.format(emi.round())),

                      summaryRow("Principal Amount",
                          indianFormat.format(principalAmount.round())),

                      summaryRow("Total Interest",
                          indianFormat.format(totalInterest.round())),

                      const Divider(height: 25),

                      summaryRow("Total Amount",
                          indianFormat.format(totalAmount.round()),
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

  //  Reusable Row
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

//  Custom Indian Comma Formatter
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

    // Add Indian comma format
    final formatted = _formatter.format(number);

    return TextEditingValue(
      text: formatted,
      selection:
          TextSelection.collapsed(offset: formatted.length),
    );
  }
}

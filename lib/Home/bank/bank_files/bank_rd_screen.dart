import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class BankRdScreen extends StatefulWidget {
  const BankRdScreen({super.key});

  @override
  State<BankRdScreen> createState() => _BankRdScreenState();
}

class _BankRdScreenState extends State<BankRdScreen> {

  final TextEditingController _monthlyController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  double investedAmount = 0;
  double estimatedReturn = 0;
  double totalAmount = 0;

  final NumberFormat indianFormat = NumberFormat('#,##,###');

  void calculateRD() {

    FocusScope.of(context).unfocus();

    double monthlyDeposit =
        double.tryParse(_monthlyController.text.replaceAll(',', '')) ?? 0;

    double rate =
        double.tryParse(_rateController.text) ?? 0;

    double years =
        double.tryParse(_timeController.text) ?? 0;

    if (monthlyDeposit <= 0 || rate <= 0 || years <= 0) return;

    int months = (years * 12).toInt();

    // Quarterly Compounding RD Formula
    double r = rate / 100;
    double maturityAmount = monthlyDeposit *
        (pow((1 + r / 4), months / 3) - 1) /
        (1 - pow((1 + r / 4), -1/3));

    double totalInvested = monthlyDeposit * months;
    double returns = maturityAmount - totalInvested;

    setState(() {
      investedAmount = totalInvested;
      estimatedReturn = returns;
      totalAmount = maturityAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          "RD Calculator",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue),
        ),
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // INPUT CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("Monthly Investment"),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _monthlyController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      IndianNumberFormatter(),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text("Return Rate (%)"),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _rateController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text("Time Period (Years)"),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _timeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: calculateRD,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Calculate RD",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // RESULT CARD
            if (totalAmount > 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "RD Summary",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),

                    const SizedBox(height: 15),

                    summaryRow(
                        "Invested Amount",
                        indianFormat.format(investedAmount.round())),

                    summaryRow(
                        "Est. Return",
                        indianFormat.format(estimatedReturn.round())),

                    const Divider(height: 25),

                    summaryRow(
                        "Total Amount",
                        indianFormat.format(totalAmount.round()),
                        isBold: true),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget summaryRow(String title, String value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            "₹$value",
            style: TextStyle(
              fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal,
              color:
                  isBold ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// Indian Number Formatter
class IndianNumberFormatter extends TextInputFormatter {

  final NumberFormat _formatter =
      NumberFormat('#,##,###');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {

    if (newValue.text.isEmpty) return newValue;

    String newText =
        newValue.text.replaceAll(',', '');

    final number = int.parse(newText);
    final formatted = _formatter.format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
          offset: formatted.length),
    );
  }
}

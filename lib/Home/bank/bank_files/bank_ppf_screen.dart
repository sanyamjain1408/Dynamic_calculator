import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class BankPpfScreen extends StatefulWidget {
  const BankPpfScreen({super.key});

  @override
  State<BankPpfScreen> createState() => _BankPpfScreenState();
}

// Indian Number Formatter
class IndianNumberFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##,###');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
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


class _BankPpfScreenState extends State<BankPpfScreen> {
  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String selectedFrequency = "Yearly";

  double investedAmount = 0;
  double estimatedReturn = 0;
  double totalAmount = 0;

  final NumberFormat indianFormat = NumberFormat('#,##,###');

  void calculatePPF() {
    FocusScope.of(context).unfocus();

    double investment =
        double.tryParse(_investmentController.text.replaceAll(',', '')) ?? 0;

    double rate = double.tryParse(_rateController.text) ?? 0;

    double years = double.tryParse(_timeController.text) ?? 0;

    if (investment <= 0 || rate <= 0 || years <= 0) return;

    double r = rate / 100;

    double yearlyInvestment =
        selectedFrequency == "Monthly" ? investment * 12 : investment;

    // 🔥 PPF Correct Formula (Annuity Due)
    double maturityAmount =
        yearlyInvestment * ((pow((1 + r), years) - 1) / r) * (1 + r);

    double totalInvested = yearlyInvestment * years;

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
      appBar: AppBar(
        title: const Text(
          "PPF Calculator",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade200,

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // INPUT CARD
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

                    const Text("Total Investment",
                    style: TextStyle(fontWeight: FontWeight.bold)
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _investmentController,
                      keyboardType: TextInputType.number,

                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        IndianNumberFormatter(),
                      ],

                      decoration: const InputDecoration(
                        hintText: "Enter Total Investment",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey,),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Return Rate (%)",
                     style: TextStyle(fontWeight: FontWeight.bold)
                     ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _rateController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: "Enter Annual Return Rate",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey,),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Time Period (Years)",
                    style: TextStyle(fontWeight: FontWeight.bold)
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _timeController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: "Enter Time Period in Years",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey,),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Frequency",
                    style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedFrequency,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Yearly",
                          child: Text("Yearly"),
                        ),
                        DropdownMenuItem(
                          value: "Monthly",
                          child: Text("Monthly"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedFrequency = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: calculatePPF,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Calculate PPF",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PPF Summary",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const SizedBox(height: 15),
                      summaryRow("Invested Amount",
                          indianFormat.format(investedAmount.round())),
                      summaryRow("Est. Return",
                          indianFormat.format(estimatedReturn.round())),
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

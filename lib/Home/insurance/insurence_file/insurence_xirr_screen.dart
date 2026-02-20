import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsurenceXirrScreen extends StatefulWidget {
  const InsurenceXirrScreen({super.key});

  @override
  State<InsurenceXirrScreen> createState() =>
      _InsurenceXirrScreenState();
}

class _InsurenceXirrScreenState
    extends State<InsurenceXirrScreen> {
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  final NumberFormat formatter = NumberFormat('#,##,###');

  DateTime? startDate;
  DateTime? endDate;
  DateTime? maturityDate;

  final TextEditingController investmentController =
      TextEditingController();
  final TextEditingController totalInvestmentController =
      TextEditingController();
  final TextEditingController maturityAmountController =
      TextEditingController();

  String selectedFrequency = "Monthly";

  double? xirrResult;

  /// ---------------- DATE PICKER ----------------
  Future<void> pickDate(
      Function(DateTime) onSelected) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  /// ---------------- FORMAT NUMBER ----------------
  void formatNumber(
      TextEditingController controller, String value) {
    String clean = value.replaceAll(',', '');
    if (clean.isEmpty) return;

    final number = int.tryParse(clean);
    if (number == null) return;

    final newText = formatter.format(number);

    controller.value = TextEditingValue(
      text: newText,
      selection:
          TextSelection.collapsed(offset: newText.length),
    );
  }

  /// ---------------- AUTO TOTAL INVESTMENT ----------------
void updateTotalInvestment() {
  if (startDate == null ||
      endDate == null ||
      investmentController.text.isEmpty) {
    totalInvestmentController.clear();
    return;
  }

  double investment = double.tryParse(
          investmentController.text.replaceAll(',', '')) ??
      0;

  int installments = 0;

  switch (selectedFrequency) {
    case "One Time":
      totalInvestmentController.text =
          formatter.format(investment.toInt());
      return;

    case "Monthly":
      installments =
          ((endDate!.year - startDate!.year) * 12) +
              (endDate!.month - startDate!.month) +
              1;
      break;

    case "Quarterly":
      installments =
          (((endDate!.year - startDate!.year) * 12) +
                      (endDate!.month - startDate!.month)) ~/
                  3 +
              1;
      break;

    case "Half Yearly":
      installments =
          (((endDate!.year - startDate!.year) * 12) +
                      (endDate!.month - startDate!.month)) ~/
                  6 +
              1;
      break;

    case "Yearly":
      installments =
          (endDate!.year - startDate!.year) + 1;
      break;

    case "14 Days":
      int totalDays =
          endDate!.difference(startDate!).inDays;
      installments = (totalDays ~/ 14) + 1;
      break;
  }

  double totalInvestment = installments * investment;

  totalInvestmentController.text =
      formatter.format(totalInvestment.toInt());
}


  /// ---------------- GENERATE CASHFLOW ----------------
List<Map<String, dynamic>> generateCashflows() {
  List<Map<String, dynamic>> flows = [];

  double investment = double.parse(
      investmentController.text.replaceAll(',', ''));

  double maturity = double.parse(
      maturityAmountController.text.replaceAll(',', ''));

  if (selectedFrequency == "One Time") {
    flows.add({"amount": -investment, "date": startDate});
  } else if (selectedFrequency == "Monthly") {
    DateTime temp = startDate!;

    while (!temp.isAfter(endDate!)) {
      flows.add({"amount": -investment, "date": temp});

      temp = DateTime(
        temp.year,
        temp.month + 1,
        temp.day,
      );
    }
  } else if (selectedFrequency == "Quarterly") {
    DateTime temp = startDate!;

    while (!temp.isAfter(endDate!)) {
      flows.add({"amount": -investment, "date": temp});

      temp = DateTime(
        temp.year,
        temp.month + 3,
        temp.day,
      );
    }
  } else if (selectedFrequency == "Half Yearly") {
    DateTime temp = startDate!;

    while (!temp.isAfter(endDate!)) {
      flows.add({"amount": -investment, "date": temp});

      temp = DateTime(
        temp.year,
        temp.month + 6,
        temp.day,
      );
    }
  } else if (selectedFrequency == "Yearly") {
    DateTime temp = startDate!;

    while (!temp.isAfter(endDate!)) {
      flows.add({"amount": -investment, "date": temp});

      temp = DateTime(
        temp.year + 1,
        temp.month,
        temp.day,
      );
    }
  } else if (selectedFrequency == "14 Days") {
    DateTime temp = startDate!;

    while (!temp.isAfter(endDate!)) {
      flows.add({"amount": -investment, "date": temp});

      temp = temp.add(const Duration(days: 14));
    }
  }

  flows.add({"amount": maturity, "date": maturityDate});

  return flows;
}


  /// ---------------- XIRR CALCULATION ----------------
  double calculateXIRR(List<Map<String, dynamic>> flows) {
    flows.sort((a, b) =>
        a["date"].compareTo(b["date"]));

    DateTime firstDate = flows.first["date"];
    double guess = 0.1;

    for (int i = 0; i < 100; i++) {
      double npv = 0;
      double derivative = 0;

      for (var flow in flows) {
        double days =
            flow["date"].difference(firstDate).inDays /
                365.0;

        double denom =
            pow(1 + guess, days).toDouble();

        npv += flow["amount"] / denom;

        derivative +=
            -days *
                flow["amount"] /
                pow(1 + guess, days + 1);
      }

      double newGuess = guess - npv / derivative;

      if ((newGuess - guess).abs() < 0.0000001) {
        return newGuess * 100;
      }

      guess = newGuess;
    }

    return guess * 100;
  }

  /// ---------------- CALCULATE BUTTON ----------------
  void calculate() {
    if (startDate == null ||
        endDate == null ||
        maturityDate == null ||
        investmentController.text.isEmpty ||
        maturityAmountController.text.isEmpty) {
      return;
    }

    List<Map<String, dynamic>> flows =
        generateCashflows();

    xirrResult = calculateXIRR(flows);

    setState(() {});
  }

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar:
          AppBar(title: const Text("XIRR Calculator",
          style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
          ),
           centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(20),
                border:
                    Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  buildDateField("Start Date",
                      startDate, (d) {
                    setState(() =>
                        startDate = d);
                    updateTotalInvestment();
                  }),

                  const SizedBox(height: 12),

                  buildTextField(
                      "Investment",
                      investmentController),

                  const SizedBox(height: 12),

                  buildDateField(
                      "End Date", endDate, (d) {
                    setState(() =>
                        endDate = d);
                    updateTotalInvestment();
                  }),

                  const SizedBox(height: 12),

                  buildDateField("Maturity Date",
                      maturityDate, (d) {
                    setState(() =>
                        maturityDate = d);
                  }),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: selectedFrequency,
                    items: const [
                      "One Time",
                      "14 Days",
                      "Monthly",
                      "Quarterly",
                      "Half Yearly",
                      "Yearly"
                    ]
                        .map((e) =>
                            DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() =>
                          selectedFrequency =
                              val!);
                      updateTotalInvestment();
                    },
                    decoration:
                        inputDecoration(
                            "Time Frequency"),
                  ),

                  const SizedBox(height: 12),

                  buildTextField(
                      "Total Investment",
                      totalInvestmentController,
                      readOnly: true),

                  const SizedBox(height: 12),

                  buildTextField(
                      "Maturity Amount",
                      maturityAmountController),

                  const SizedBox(height: 20),

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
                      onPressed: calculate,
                      child: const Text(
                          "Calculate XIRR",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (xirrResult != null)
              Container(
                padding:
                    const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(
                          16),
                  border: Border.all(
                      color: Colors.blue),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Extended Internal Rate Of Return",
                      style: TextStyle(
                          fontWeight:
                              FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${xirrResult!.toStringAsFixed(2)}%",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            xirrResult! < 0
                                ? Colors.red
                                : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildDateField(
      String label,
      DateTime? date,
      Function(DateTime) onSelect) {
    return InkWell(
      onTap: () => pickDate(onSelect),
      child: InputDecorator(
        decoration:
            inputDecoration(label),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
          children: [
            Text(date == null
                ? ""
                : dateFormat
                    .format(date)),
            const Icon(
                Icons.calendar_today)
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String label,
      TextEditingController controller,
      {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType:
          TextInputType.number,
      decoration:
          inputDecoration(label),
      onChanged: (value) {
        formatNumber(controller, value);
        updateTotalInvestment();
      },
    );
  }

  InputDecoration inputDecoration(
      String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
    );
  }
}

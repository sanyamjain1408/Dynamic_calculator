import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsuranceIrrScreen extends StatefulWidget {
  const InsuranceIrrScreen({super.key});

  @override
  State<InsuranceIrrScreen> createState() => _InsuranceIrrScreenState();
}

class _InsuranceIrrScreenState extends State<InsuranceIrrScreen> {
  final TextEditingController investmentController = TextEditingController();
  final FocusNode investmentFocusNode = FocusNode();

  List<TextEditingController> cashFlowControllers = [];
  List<FocusNode> focusNodes = [];

  double irrResult = double.nan;
  double netCashFlow = 0.0;

  final formatter = NumberFormat('#,##,##0');

  @override
  void initState() {
    super.initState();

    addCashFlowField();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(investmentFocusNode);
      }
    });
  }

  @override
  void dispose() {
    investmentController.dispose();
    investmentFocusNode.dispose();
    for (var c in cashFlowControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void addCashFlowField() {
    final controller = TextEditingController();
    final focusNode = FocusNode();

    setState(() {
      cashFlowControllers.add(controller);
      focusNodes.add(focusNode);
    });
  }

  void formatNumber(TextEditingController controller, String value) {
    if (value.isEmpty) return;

    bool isNegative = value.startsWith('-');
    String clean = value.replaceAll(',', '').replaceAll('-', '');

    final number = int.tryParse(clean);
    if (number == null) return;

    String formatted = formatter.format(number);

    if (isNegative) {
      formatted = '-$formatted';
    }

    controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  // ✅ Stable IRR Calculation (Bisection Method)
  double? calculateIRR(List<double> cashFlows) {
    double low = -0.9999;
    double high = 10.0;
    double mid = 0.0;

    double npv(double rate) {
      double total = 0.0;
      for (int t = 0; t < cashFlows.length; t++) {
        total += cashFlows[t] / pow((1 + rate), t);
      }
      return total;
    }

    if (npv(low) * npv(high) > 0) {
      return null;
    }

    for (int i = 0; i < 1000; i++) {
      mid = (low + high) / 2;
      double value = npv(mid);

      if (value.abs() < 0.00001) {
        return mid * 100;
      }

      if (npv(low) * value < 0) {
        high = mid;
      } else {
        low = mid;
      }
    }

    return mid * 100;
  }

  void calculate() {
    FocusScope.of(context).unfocus();

    List<double> cashFlows = [];

    double investment =
        double.tryParse(investmentController.text.replaceAll(',', '')) ?? 0;

    cashFlows.add(-investment);

    double totalCashInflow = 0;

    for (var controller in cashFlowControllers) {
      double value =
          double.tryParse(controller.text.replaceAll(',', '')) ?? 0;

      cashFlows.add(value);
      totalCashInflow += value;
    }

    netCashFlow = totalCashInflow - investment;

    final irr = calculateIRR(cashFlows);

    irrResult = irr ?? double.nan;

    setState(() {});
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true),
        textInputAction:
            nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          formatNumber(controller, value);
        },
        onSubmitted: (_) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else {
            calculate();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          "IRR Calculator",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
                color: Colors.grey.shade100,
              ),
              child: Column(
                children: [
                  buildTextField(
                    controller: investmentController,
                    focusNode: investmentFocusNode,
                    nextFocusNode:
                        focusNodes.isNotEmpty ? focusNodes[0] : null,
                    label: "Initial Investment",
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cashFlowControllers.length,
                    itemBuilder: (context, index) {
                      return buildTextField(
                        controller: cashFlowControllers[index],
                        focusNode: focusNodes[index],
                        nextFocusNode: index < focusNodes.length - 1
                            ? focusNodes[index + 1]
                            : null,
                        label: "Cash Flow Year ${index + 1}",
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                          onPressed: addCashFlowField,
                          child: const Text("ADD",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
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
                          child: const Text("Calculate IRR",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue),
                color: Colors.blue.shade50,
              ),
              child: Column(
                children: [
                  const Text(
                    "Internal Rate Of Return",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    irrResult.isNaN
                        ? "IRR Not Possible"
                        : "${irrResult.toStringAsFixed(2)}%",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: irrResult.isNaN
                          ? Colors.grey
                          : irrResult < 0
                              ? Colors.red
                              : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Net Profit / Loss",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formatter.format(netCashFlow),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          netCashFlow < 0 ? Colors.red : Colors.green,
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
}

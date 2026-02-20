import 'package:flutter/material.dart';

class BankSwpScreen extends StatefulWidget {
  const BankSwpScreen({super.key});

  @override
  State<BankSwpScreen> createState() => _BankSwpScreenState();
}

class _BankSwpScreenState extends State<BankSwpScreen> {

  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _withdrawController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  double investedAmount = 0;
  double monthlyWithdrawal = 0;
  double totalWithdrawn = 0;
  double finalAmount = 0;

  void calculateSWP() {
    FocusScope.of(context).unfocus();

    double P = double.tryParse(_investmentController.text) ?? 0;
    double W = double.tryParse(_withdrawController.text) ?? 0;
    double r = double.tryParse(_rateController.text) ?? 0;
    double t = double.tryParse(_timeController.text) ?? 0;

    if (P <= 0 || W <= 0 || r < 0 || t <= 0) {
      setState(() {
        investedAmount = 0;
        monthlyWithdrawal = 0;
        totalWithdrawn = 0;
        finalAmount = 0;
      });
      return;
    }

    int totalMonths = (t * 12).toInt();

    //  Nominal Monthly Rate (IMPORTANT)
    double monthlyRate = r / 100 / 12;

    double balance = P;

    for (int i = 0; i < totalMonths; i++) {
      balance -= W;                    // Withdrawal at beginning
      balance += balance * monthlyRate; // Monthly interest
    }

    if (balance < 0) balance = 0;

    setState(() {
      investedAmount = P;
      monthlyWithdrawal = W;
      totalWithdrawn = W * totalMonths;
      finalAmount = double.parse(balance.toStringAsFixed(0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SWP Calculator",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
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

                  const Text("Total Investment",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _investmentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text("Withdrawal (per month)",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _withdrawController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text("Return Rate (% per year)",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _rateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
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
                      onPressed: calculateSWP,
                      child: const Text(
                        "Calculate SWP",
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

            /// SUMMARY
            if (investedAmount > 0)
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
                      "SWP Summary",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),

                    const SizedBox(height: 15),

                    buildRow("Invested Amount :", investedAmount),
                    buildRow("Withdrawal (P.M) :", monthlyWithdrawal),
                    buildRow("Total Withdrawn :", totalWithdrawn),

                    const Divider(height: 25),

                    buildRow("Final Amount :", finalAmount, isFinal: true),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String title, double value, {bool isFinal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight:
                      isFinal ? FontWeight.bold : FontWeight.normal)),
          Text(
            "₹${value.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight:
                  isFinal ? FontWeight.bold : FontWeight.normal,
              color: isFinal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CaEMIScreen extends StatefulWidget {
  const CaEMIScreen({super.key});

  @override
  State<CaEMIScreen> createState() => _CaEMIScreenState();
}

class _CaEMIScreenState extends State<CaEMIScreen> {

  final TextEditingController _loanController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  double emi = 0;
  double principalAmount = 0;
  double totalInterest = 0;
  double totalAmount = 0;

  bool isLoading = false;

  final String baseUrl = "http://192.168.1.2:8000";

  Future<void> calculateEMI() async {
    FocusScope.of(context).unfocus();

    double loanAmount = double.tryParse(_loanController.text) ?? 0;
    double interestRate = double.tryParse(_rateController.text) ?? 0;
    double timeInYears = double.tryParse(_timeController.text) ?? 0;

    if (loanAmount <= 0 || interestRate <= 0 || timeInYears <= 0) return;

    setState(() => isLoading = true);

    final url = "$baseUrl/ca_app/emi/calculate/";

    final requestBody = {
      "calculator_type": "emi calculator",
      "loan_amount": loanAmount,
      "interest_rate": interestRate,
      "time_in_years": timeInYears,
    };

    print("------------------------- POST REQUEST ---------------------------------");
    print("URL: $url");
    print("BODY: ${jsonEncode(requestBody)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

       print("----------------------------- POST RESPONSE -----------------------------");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final result = data["result"];

        setState(() {
          emi = (result["emi"] ?? 0).toDouble();
          principalAmount = (result["principal_amount"] ?? 0).toDouble();
          totalInterest = (result["total_interest"] ?? 0).toDouble();
          totalAmount = (result["total_amount"] ?? 0).toDouble();
        });
      } else {
        print("Post Error: ${response.body}");
      }
    } catch (e) {
      print("Connection failed: $e");
    } finally {
      setState(() => isLoading = false);
    }
  } 

   @override
  void dispose() {
    _loanController.dispose();
    _rateController.dispose();
    _timeController.dispose();
    super.dispose();
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
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey,),
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
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey,),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: calculateEMI,
                        child:isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            :  const Text(
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


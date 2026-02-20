import 'package:flutter/material.dart';

class CaGstScreen extends StatefulWidget {
  const CaGstScreen({super.key});

  @override
  State<CaGstScreen> createState() => _CaGstScreenState();
}

class _CaGstScreenState extends State<CaGstScreen> {

  final TextEditingController _amountController = TextEditingController();

  String selectedCalculationType = "Exclusive";
  String selectedGstType = "GST";
  double selectedGstRate = 18;

  double netAmount = 0;
  double taxAmount = 0;
  double totalAmount = 0;

  double igst = 0;
  double cgst = 0;
  double sgst = 0;

  void calculateGST() {
    FocusScope.of(context).unfocus(); // hide keyboard

    double amount = double.tryParse(_amountController.text) ?? 0;

    if (amount <= 0) return;

    if (selectedCalculationType == "Exclusive") {
      netAmount = amount;
      taxAmount = (amount * selectedGstRate) / 100;
      totalAmount = amount + taxAmount;
    } else {
      totalAmount = amount;
      netAmount = amount / (1 + selectedGstRate / 100);
      taxAmount = totalAmount - netAmount;
    }

    igst = 0;
    cgst = 0;
    sgst = 0;

    if (selectedGstType == "GST") {
      // Show full GST
      igst = taxAmount;
    } 
    else if (selectedGstType == "IGST") {
      igst = taxAmount;
    } 
    else {
      cgst = taxAmount / 2;
      sgst = taxAmount / 2;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("GST Calculator", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
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
                      "Amount",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),
                      
                  /// Amount Field
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter Amount",
                      border: OutlineInputBorder(),
                    ),
                  ),
                      
                  const SizedBox(height: 20),
                      
                  /// GST Rate Dropdown
                  DropdownButtonFormField<double>(
                    value: selectedGstRate,
                    decoration: const InputDecoration(
                      labelText: "GST Rate (%)",
                      border: OutlineInputBorder(),
                    ),
                    items: [5, 12, 18, 28]
                        .map((rate) => DropdownMenuItem(
                              value: rate.toDouble(),
                              child: Text("$rate%"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGstRate = value!;
                      });
                    },
                  ),
                      
                  const SizedBox(height: 15),
                      
                  /// Calculation Type
                  DropdownButtonFormField<String>(
                    value: selectedCalculationType,
                    decoration: const InputDecoration(
                      labelText: "Calculation Type",
                      border: OutlineInputBorder(),
                    ),
                    items: ["Exclusive", "Inclusive"]
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCalculationType = value!;
                      });
                    },
                  ),
                      
                  const SizedBox(height: 15),
                      
                  /// GST Type
                  DropdownButtonFormField<String>(
                    value: selectedGstType,
                    decoration: const InputDecoration(
                      labelText: "GST Type",
                      border: OutlineInputBorder(),
                    ),
                    items: ["GST", "IGST", "CGST/SGST"]
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGstType = value!;
                      });
                    },
                  ),
                      
                  const SizedBox(height: 20),
                      
                  /// Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      onPressed: calculateGST,
                     child: const Text("Calculate Tax", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                      
                  const SizedBox(height: 20),
                      
                  
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Summary Card
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
                            "Tax Summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Net Amount :"),
                              Text(
                                "₹${netAmount.toStringAsFixed(2)}",
                              ),
                            ],
                          ),
                      
                          
                      
                          
                      
                          if (selectedGstType == "GST")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             Text("GST (${selectedGstRate}%):"),
                              Text("₹${taxAmount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.red)),
                            ],
                          ),

                      
                          if (selectedGstType == "IGST")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("IGST (${selectedGstRate}%):"),
                              Text("${igst.toStringAsFixed(2)}", style: const TextStyle(color: Colors.red))
                            ],
                          ),


                           
                      
                          if (selectedGstType == "CGST/SGST") ...[
                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("CGST (${selectedGstRate / 2}%):"),
                              Text("${cgst.toStringAsFixed(2)}", style: const TextStyle(color: Colors.red))
                            ],
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("SGST (${selectedGstRate / 2}%): "),
                              Text("${sgst.toStringAsFixed(2)}", style: const TextStyle(color: Colors.red))
                            ],
                          ),
                          ],
                      
                          const Divider(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                            "Total Amount :",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, ),
                          ),
                           Text(
                            "₹${totalAmount.toStringAsFixed(2)}",
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
            ]
            
          ),
        ),
      ),
    );
  }
}

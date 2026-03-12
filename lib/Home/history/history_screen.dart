import 'dart:convert';
import 'package:calculator/Home/home_screen.dart';
import 'package:calculator/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'history_detail_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class IndianNumberFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##,###');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
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

class _HistoryScreenState extends State<HistoryScreen> {
  List historyList = [];
  List filteredList = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();

  DateTime? selectedDate;

  final NumberFormat indianFormat = NumberFormat('#,##,###');

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  Future<void> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = "${ApiConfig.baseUrl}/ca_app/calculator-history/";

    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Token $token",
      },
    );

    print("------------------------------History----------------------------------------");
    print("Status Code: ${response.statusCode}");
    print("History API Response: ${response.body}");

    var data = jsonDecode(response.body);

    setState(() {
      isLoading = false;

      if (data["history"] != null) {
        historyList = data["history"];
        filteredList = historyList; // important
      } else {
        historyList = [];
        filteredList = [];
      }
    });
  }

  Future<void> shareCalculation(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = "${ApiConfig.baseUrl}/ca_app/history/download/$id/";

    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Token $token",
      },
    );

    var data = jsonDecode(response.body);

    if (data["link"] != null) {
      Share.share(data["link"]);
    }
  }

  Future<void> generatePDF(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Calculation Report", style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text("Calculator: ${data["calculator_name"]}"),
              pw.Text("Amount: ${data["amount"]}"),
              pw.Text("GST Rate: ${data["gst_rate"]}%"),
              pw.Text("Total Amount: ${data["total_amount"]}"),
              pw.Text("Date: ${data["created_at"]}"),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> deleteHistory(int cardId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = "${ApiConfig.baseUrl}/ca_app/history/delete/$cardId/";

    var response = await http.delete(
      Uri.parse(url),
      headers: {
        "Authorization": "Token $token",
      },
    );

    print("DELETE STATUS: ${response.statusCode}");
    print("DELETE RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      /// list refresh
      getHistory();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("History deleted successfully")),
      );
    }
  }

  void filterHistory() {
    String searchText = searchController.text.replaceAll(",", "").trim();

    setState(() {
      if (searchText.isEmpty && selectedDate == null) {
        filteredList = historyList;
        return;
      }

      int searchNumber = int.tryParse(searchText) ?? 0;

      filteredList = historyList.where((item) {
        bool amountMatch = true;
        bool dateMatch = true;

        /// Amount filter
        if (searchText.isNotEmpty) {
          int amount = (double.tryParse(item["total_amount"].toString()) ?? 0).toInt();

          /// yaha change hai
          amountMatch = amount.toString().startsWith(searchText);
        }

        /// Date filter
        if (selectedDate != null) {
          String itemDate = item["created_at"].toString().substring(0, 10);

          String pickedDate = selectedDate.toString().substring(0, 10);

          dateMatch = itemDate == pickedDate;
        }

        return amountMatch && dateMatch;
      }).toList();
    });
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate = picked;
      filterHistory();
    }
  }

  Widget historyCard(item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryDetailScreen(data: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item["calculator_name"]?.toString() ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(item["created_at"]?.toString().substring(0, 10) ?? "")
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "Amount : ₹${indianFormat.format(double.tryParse(item["total_amount"].toString())?.round() ?? 0)}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  color: Colors.blue,
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    if (item["id"] != null) {
                      shareCalculation(int.parse(item["id"].toString()));
                    }
                  },
                ),
                IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    generatePDF(item);
                  },
                ),
                IconButton(
                    color: Colors.red,
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete History"),
                          content: const Text("Are you sure you want to delete this record?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                if (item["card_id"] != null) {
                                  deleteHistory(int.parse(item["card_id"].toString()));
                                }
                              },
                              child: const Text("Delete"),
                            )
                          ],
                        ),
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.blue[400], // AppBar background color
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                /// Search Amount
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: searchController,
                      keyboardType: TextInputType.number,

                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        IndianNumberFormatter(),
                      ],

                      decoration: const InputDecoration(
                        hintText: "Search Amount (₹)",
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),

                      ///  automatic search
                      onChanged: (value) {
                        filterHistory();
                      },

                      /// done press
                      onSubmitted: (value) {
                        filterHistory();
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// Date Picker Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      pickDate();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : historyList.isEmpty
                  ? const Center(child: Text("No History Found"))
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return historyCard(filteredList[index]);
                      },
                    ),
        ),
      ),
    );
  }
}

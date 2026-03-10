import 'dart:convert';
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
  bool isLoading = true;

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
      } else {
        historyList = [];
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
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    if (item["id"] != null) {
                      shareCalculation(int.parse(item["id"].toString()));
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    generatePDF(item);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : historyList.isEmpty
                ? const Center(child: Text("No History Found"))
                : ListView.builder(
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      return historyCard(historyList[index]);
                    },
                  ),
      ),
    );
  }
}

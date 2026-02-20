import 'package:calculator/Home/bank/bank_files/bank_emi_screen.dart';
import 'package:calculator/Home/bank/bank_files/bank_fd_screen.dart';
import 'package:calculator/Home/bank/bank_files/bank_ppf_screen.dart';
import 'package:calculator/Home/bank/bank_files/bank_sip_screen.dart';
import 'package:calculator/Home/bank/bank_files/bank_rd_screen.dart';
import 'package:calculator/Home/bank/bank_files/bank_swp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {

  final List<Map<String, dynamic>> items = [
    {
      "title": "EMI\nCalculator",
      "image": "assets/emi_picture.png",
      "screen": const BankEmiScreen(),
    },
    {
      "title": "SIP\nCalculator",
      "image": "assets/sip_picture.png",
      "screen": const BankSipScreen(),
    },
    {
      "title": "SWP\nCalculator",
      "image": "assets/swp_picture.png",
      "screen": const BankSwpScreen(),
    },
    {
      "title": "FD\nCalculator",
      "image": "assets/fd_picture.png",
      "screen": const BankFdScreen(),
    },
    {
      "title": "RD\nCalculator",
      "image": "assets/rd_picture.png",
      "screen": const BankRdScreen(),
    },
    {
      "title": "PPF\nCalculator",
      "image": "assets/ppf_picture.png",
      "screen": const BankPpfScreen(),
    },
  ];

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        title: const Text(
          "Banking",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 40,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => item["screen"],
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      height: 81,
                      width: 81,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Image.asset(
                          item["image"],
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileAboutScreen extends StatefulWidget {
  const ProfileAboutScreen({super.key});

  @override
  State<ProfileAboutScreen> createState() => _ProfileAboutScreenState();
}

class _ProfileAboutScreenState extends State<ProfileAboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            Center(
              child: Image.asset(
                "assets/about.png",
                height: 200,
              ),
            ),

            const SizedBox(height: 25),

            /// TITLE
            const Text(
              "About SmartCalc",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            /// DESCRIPTION
            const Text(
              "Our Calculation App is designed to provide fast, accurate, and convenient financial and business calculations in one place. Whether you are a professional from a CA firm, banking sector, insurance industry, or an individual user, our app offers a wide range of tools including EMI, Income Tax, SIP, FD, RD, GST, IRR, XIRR, and more. We aim to simplify complex calculations with an easy-to-use interface, reliable results, and a seamless user experience. Our mission is to save your time, improve accuracy, and help you make smarter financial decisions anytime, anywhere.",
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "If you need help or you have any questions, feel free to contact us by email.",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 10),

            /// EMAIL
            const Text(
              "hello@smartcalc.com",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

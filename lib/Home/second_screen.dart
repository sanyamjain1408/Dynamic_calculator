import 'package:calculator/Home/bank/bank_screen.dart';
import 'package:calculator/Home/ca/ca_screen.dart';
import 'package:calculator/Home/insurance/insurance_screen.dart';
import 'package:calculator/Home/property/property_screen.dart';
import 'package:flutter/material.dart';


class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context)  {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
         backgroundColor: Colors.white,
         body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [


                SizedBox(height: 26),


                /// Card 1: CA Firm
                buildCard(
                  context,
                  title: "CA Farm",
                  
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CaScreen(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 26),


                /// Card 2: Banking
                buildCard(
                  context,
                  title: "Banking",
                  
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BankScreen(),
                      ),
                    );
                  },
                ),


                SizedBox(height: 26),


                /// Card 3: Insurance
                buildCard(
                  context,
                  title: "Insurance",
                  
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InsuranceScreen(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 26),


                /// Card 4: Property & Utility
                buildCard(
                  context,
                  title: "Property & Utility",
                  
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PropertyScreen(),
                      ),
                    );
                  },
                ),
               
                
                
              ],
            ),
          ),
         ),
      ),
    );
  }

 Widget buildCard(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  })  {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE9ECFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        alignment: Alignment.center,
        child:  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
      ),
    );
  }
}
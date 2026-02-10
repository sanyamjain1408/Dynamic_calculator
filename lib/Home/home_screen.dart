import 'package:calculator/Home/bank/bank_screen.dart';
import 'package:calculator/Home/ca/ca_screen.dart';
import 'package:calculator/Home/calculator/calculator_screen.dart';
import 'package:calculator/Home/insurance/insurance_screen.dart';
import 'package:calculator/widgets/appdrawer.dart';
import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/bottom_nav.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  /// ✅ CENTER PAGES LIST
  final List<Widget> pages = const [
    CalculatorScreen(),   // Calc
    CaScreen(),     // CA
    BankScreen(),   // Bank
    InsuranceScreen(), // Insurance
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      /// Drawer
      drawer: const AppDrawer(),

      /// 🔒 HEADER (STATIC)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppHeader(scaffoldKey: _scaffoldKey),
      ),

      /// 🔁 ONLY CENTER CONTENT CHANGES
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      /// 🔒 FOOTER (STATIC)
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

import 'package:calculator/Home/bank/bank_screen.dart';
import 'package:calculator/Home/ca/ca_screen.dart';
import 'package:calculator/Home/calculator/calculator_screen.dart';
import 'package:calculator/Home/history/history_screen.dart';
import 'package:calculator/Home/insurance/insurance_screen.dart';
import 'package:calculator/Home/emaillogin_screen.dart';
import 'package:calculator/Home/profile/profile_screen.dart';
import 'package:calculator/Home/second_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  /// ✅ CENTER PAGES LIST
  final List<Widget> pages = const [
    CalculatorScreen(), // Calc
    SecondScreen(), // CA
    HistoryScreen(), // History
    ProfileScreen(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

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
        onTap: (index) async {
          // History index = 2
          // Profile index = 3

          if (index == 2 || index == 3) {
            bool isLoggedIn = await checkLogin();

            if (!isLoggedIn) {
              showLoginDialog(index);
              return; // yaha se stop ho jayega
            }
          }

          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  void showLoginDialog(int index) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Login Required",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeInOut);

        return ScaleTransition(
          scale: curved,
          child: FadeTransition(
            opacity: curved,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text("Login Required"),
              content: const Text("First login yourself to continue."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // dialog close

                    Future.delayed(const Duration(milliseconds: 200), () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder: (_, animation, secondaryAnimation) =>
                               EmailLoginScreen(
                                onLoginSuccess: (){
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                               ),
                          transitionsBuilder:
                              (_, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    });
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

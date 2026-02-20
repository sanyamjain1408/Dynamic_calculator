import 'package:calculator/Home/home_screen.dart';
import 'package:flutter/material.dart';

class OtpAuthentication extends StatefulWidget {
  final String mobileNumber;

  const OtpAuthentication({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<OtpAuthentication> createState() => _OtpAuthenticationState();
}

class _OtpAuthenticationState extends State<OtpAuthentication> {
  String otp = "";

  void onOtpTap(String number) {
    if (otp.length < 6) {
      setState(() {
        otp += number;
      });
    }
  }

  void onBackspace() {
    if (otp.isNotEmpty) {
      setState(() {
        otp = otp.substring(0, otp.length - 1);
      });
    }
  }

  /// 🔹 KEYPAD BUTTON
  Widget buildKey(
    String text, {
    VoidCallback? onTap,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 3),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // HEADING
            const Text(
              "Enter your 6-digit code",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "OTP sent to +91 ${widget.mobileNumber}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            // OTP DISPLAY
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: 220,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Text(
                otp.padRight(6, "-"),
                style: const TextStyle(
                  fontSize: 22,
                  letterSpacing: 10,
                ),
              ),
            ),

            const Spacer(),

            // 🔢 KEYPAD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  for (var row in [
                    ["1", "2", "3"],
                    ["4", "5", "6"],
                    ["7", "8", "9"],
                    ["⌫", "0", "->>"],
                  ])
                    Row(
                      children: row.map((e) {
                        if (e == "⌫") {
                          return Expanded(
                            child: buildKey(
                              e,
                              onTap: onBackspace,
                            ),
                          );
                        } else if (e == "->>") {
                          return Expanded(
                            child: buildKey(
                              e,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              onTap: () {
                                if (otp.length == 6) {
                                  // ✅ TOAST / POPUP
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("OTP Verified"),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 1),
                                    ),
                                  );

                                  // ✅ DELAY + PAGE TRANSITION
                                  Future.delayed(
                                      const Duration(milliseconds: 800), () {
                                    // Navigator.pushAndRemoveUntil(
                                    //   context,
                                    //   PageRouteBuilder(
                                    //     transitionDuration:
                                    //         const Duration(milliseconds: 600),
                                    //     pageBuilder: (context, animation, _) =>
                                    //         const HomeScreen(),
                                    //     transitionsBuilder:
                                    //         (context, animation, _, child) {
                                    //       return FadeTransition(
                                    //         opacity: animation,
                                    //         child: child,
                                    //       );
                                    //     },
                                    //   ),
                                    //   (route) =>
                                    //       false, // 🔥 ye line OTP ko stack se hata degi
                                    // );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Enter 6 digit OTP"),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        } else {
                          return Expanded(
                            child: buildKey(
                              e,
                              onTap: () => onOtpTap(e),
                            ),
                          );
                        }
                      }).toList(),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

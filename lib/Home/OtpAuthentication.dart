import 'package:calculator/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class OtpAuthentication extends StatefulWidget {
  final String email;
  final VoidCallback? onLoginSuccess;

  const OtpAuthentication({
    super.key,
    required this.email,
    this.onLoginSuccess,
  });

  @override
  State<OtpAuthentication> createState() => _OtpAuthenticationState();
}

class _OtpAuthenticationState extends State<OtpAuthentication> {

  String otp = "";
  bool isLoading = false;

  final String baseUrl = "http://192.168.1.5:8000";

  Future<void> saveLogin(String email, String name) async {

  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool("isLoggedIn", true);
  await prefs.setString("email", email);
  await prefs.setString("name", name);

}



  // OTP TYPE FUNCTION
  void onOtpTap(String number) {
    if (otp.length < 6) {
      setState(() {
        otp += number;
      });
    }
  }

  // BACKSPACE
  void onBackspace() {
    if (otp.isNotEmpty) {
      setState(() {
        otp = otp.substring(0, otp.length - 1);
      });
    }
  }

  // VERIFY OTP API
  Future<void> verifyOtp() async {

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter 6 digit OTP")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = "$baseUrl/ca_app/login/verify-otp/";

    final requestBody = {
      "email": widget.email,
      "otp": otp,
    };

    print("------------------------- POST REQUEST ---------------------------------");
    print("URL: $url");
    print("BODY: ${jsonEncode(requestBody)}");

    try {

      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print("----------------------------- POST RESPONSE -----------------------------");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      var data = jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      if (data["status"] == true) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP Verified"),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(const Duration(milliseconds: 700), () async{

          await saveLogin(
            data["user"]["email"],
            data["user"]["name"] ?? "User");

          widget.onLoginSuccess?.call();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
          );

        });

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"]),
            backgroundColor: Colors.red,
          ),
        );

      }

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      print("Error Occurred: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Enter Valid OTP")),
      );

    }
  }

  // KEYPAD BUTTON
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

            const Text(
              "Enter your 6-digit code",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "OTP sent to ${widget.email}",
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

            // KEYPAD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [

                  for (var row in [
                    ["1","2","3"],
                    ["4","5","6"],
                    ["7","8","9"],
                    ["⌫","0","->>"]
                  ])

                  Row(
                    children: row.map((e){

                      if(e=="⌫"){
                        return Expanded(
                          child: buildKey(
                            e,
                            onTap: onBackspace,
                          ),
                        );
                      }

                      else if(e=="->>"){
                        return Expanded(
                          child: buildKey(
                            e,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            onTap: verifyOtp,
                          ),
                        );
                      }

                      else{
                        return Expanded(
                          child: buildKey(
                            e,
                            onTap: ()=> onOtpTap(e),
                          ),
                        );
                      }

                    }).toList(),
                  )

                ],
              ),
            ),

            const SizedBox(height: 15),

            if(isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: CircularProgressIndicator(),
              )

          ],
        ),
      ),
    );
  }
}

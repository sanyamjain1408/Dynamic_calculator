import 'package:calculator/Home/emailsignup_screen.dart';
import 'package:flutter/material.dart';
import 'OtpAuthentication.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class EmailLoginScreen extends StatefulWidget {

  final VoidCallback? onLoginSuccess;
  const EmailLoginScreen({super.key, this.onLoginSuccess});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  final String baseUrl = "http://192.168.1.5:8000";

  Future<void> saveLogin() async {

  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool("isLoggedIn", true);

}


  Future<void> sendOtp() async {
    print("SEND OTP FUNCTION CALLED");
    
    String email = emailController.text.trim();

    if (email.isEmpty || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid email")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = "$baseUrl/ca_app/login/send-otp/";

    final requestBody ={
      "user email" : email,
    };

    print("------------------------- POST REQUEST ---------------------------------");
    print("URL: $url");
    print("BODY: ${jsonEncode(requestBody)}");

    try {
      var response = await http.post(
        Uri.parse(url), // 🔥 Apna real backend URL
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
        }),
      );

      print("----------------------------- POST RESPONSE -----------------------------");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");



      var data = jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 404) {
        if (data["status"] == true) {
          //  OTP Sent Success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data["message"]),
              backgroundColor: Colors.green,
            ),
          );

          //  Smooth Slide to OTP Screen
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (_, animation, secondaryAnimation) =>
                  OtpAuthentication(
                    email: email,
                    onLoginSuccess: widget.onLoginSuccess,),
              transitionsBuilder: (_, animation, secondaryAnimation, child) {
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
        } else {
          //  USER NOT REGISTERED
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Not Registered"),
              content: const Text("First register yourself"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    //  Signup Screen pe bhejo
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EmailsignupScreen(),
                      ),
                    );
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server Error")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print("Error Occurred: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network Error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text(
                "Login with Email",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Email Address",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Send OTP",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

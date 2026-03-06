import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailsignupScreen extends StatefulWidget {
  const EmailsignupScreen({super.key});

  @override
  State<EmailsignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailsignupScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  bool isLoading = false;

  final String baseUrl = "http://192.168.1.5:8000";

  Future<void> registerUser() async {

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String mobile = numberController.text.trim();

    if (name.isEmpty || email.isEmpty || mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = "$baseUrl/ca_app/register/";

    final requestBody = {
      "name": name,
          "email": email,
          "mobile": mobile,
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
      print("Response Body: ${response.body}");

      var data = jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 && data["status"] == true) {

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Success"),
            content: Text(data["message"]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // go back to login
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Error")),
        );
      }

    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server Error")),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 60),

                const Text(
                  "Signup",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                buildField("Full Name", nameController),
                const SizedBox(height: 20),

                buildField("Email Address", emailController),
                const SizedBox(height: 20),

                buildField("Mobile Number", numberController,
                    keyboard: TextInputType.phone),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(String hint, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {

    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
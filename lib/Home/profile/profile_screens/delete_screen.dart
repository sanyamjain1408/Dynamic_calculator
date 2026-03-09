import 'dart:convert';
import 'package:calculator/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calculator/config/app_config.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  bool loading = false;
Future<void> deleteAccount() async {
    setState(() {
      loading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final url = "${ApiConfig.baseUrl}/ca_app/delete-account/";

      print("DELETE API URL: $url");
      print("TOKEN: $token");

      var response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );

      print("DELETE RESPONSE: ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await prefs.clear();

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
            ),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account deleted successfully"),
          ),
        );
        Future.delayed(const Duration(milliseconds: 700), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["detail"] ?? "Delete failed")),
        );
      }
    } catch (e) {
      print("DELETE ERROR: $e");
    }

    setState(() {
      loading = false;
    });
  }


  /// CONFIRM DELETE POPUP
  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
            "This action cannot be undone.\n\nAre you sure you want to permanently delete your account?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteAccount();
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              /// DELETE ICON
              Image.asset(
                "assets/delete.png",
                height: 90,
              ),

              const SizedBox(height: 25),

              const Text(
                "Are you sure ? you want to",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Delete your account?",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 35),

              /// BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// NO BUTTON
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(110, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "No",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  const SizedBox(width: 20),

                  /// YES BUTTON
                  ElevatedButton(
                    onPressed: loading ? null : confirmDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.red),
                      minimumSize: const Size(110, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red,
                            ),
                          )
                        : const Text(
                            "YES",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

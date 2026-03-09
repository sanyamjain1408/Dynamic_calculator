import 'package:calculator/Home/profile/profile_screens/delete_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePersonalinfoScreen extends StatefulWidget {
  const ProfilePersonalinfoScreen({super.key});

  @override
  State<ProfilePersonalinfoScreen> createState() => _ProfilePersonalinfoScreenState();
}

class _ProfilePersonalinfoScreenState extends State<ProfilePersonalinfoScreen> {
  String name = "XXX";
  String email = "XXX";
  String phone = "XXX";
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    bool login = prefs.getBool("isLoggedIn") ?? false;

    setState(() {
      isLoggedIn = login;

      if (login) {
        name = prefs.getString("name") ?? "XXX";
        email = prefs.getString("email") ?? "XXX";
        phone = prefs.getString("phone") ?? "XXX";
      } else {
        name = "XXX";
        email = "XXX";
        phone = "XXX";
      }
    });
  }

  Widget infoTile(IconData icon, String title, String value) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// PROFILE ICON
            
            Row(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),

                SizedBox(width: 30,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      email,
                      style: const TextStyle(color: Colors.grey),
                    ),

                  ],
                )
              ],),

           const SizedBox(height: 30,),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  infoTile(Icons.person_outline, "FULL NAME", name),
                  const SizedBox(height: 18),
                  infoTile(Icons.email_outlined, "EMAIL", email),
                  const SizedBox(height: 18),
                  infoTile(Icons.phone_outlined, "PHONE NUMBER", phone),
                ],
              ),
            ),

            const Spacer(),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeleteScreen(),
                  ),
                );
              },
              child: const Text(
                "Delete your account?",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

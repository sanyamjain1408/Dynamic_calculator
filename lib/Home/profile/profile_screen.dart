import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String name = "";
  String email = "";
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
      name = prefs.getString("name") ?? "User";
      email = prefs.getString("email") ?? "";
    });

  }

  Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    setState(() {
      isLoggedIn = false;
      name = "";
      email = "";
    });

  }

  Widget buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon,color: Colors.black54),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios,size: 16),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade200,

      body: Column(

        children: [

          /// PROFILE HEADER
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [

                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person,size: 35,color: Colors.white),
                ),

                const SizedBox(width: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      name.isEmpty ? "Guest User" : name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      email.isEmpty ? "Not Logged In" : email,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),

          const Divider(),

          /// MENU LIST
          buildMenuItem(Icons.info_outline,"Personal Info"),
          buildMenuItem(Icons.credit_card,"Subscription"),
          buildMenuItem(Icons.help_outline,"Help"),
          buildMenuItem(Icons.article_outlined,"Terms & Conditions"),
          buildMenuItem(Icons.info,"About Us"),

          const Spacer(),

          /// LOGOUT BUTTON
          if(isLoggedIn)
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                onPressed: logout,

                child: const Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            ),
          ),

        ],
      ),

    );

  }
}

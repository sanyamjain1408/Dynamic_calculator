import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          /// Profile Section
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue[100]),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/profile_logo.png'),
                ),
                SizedBox(height: 10),
                Text("Sanyam Jain",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("sanyam@email.com",
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ),

          /// Menu Items
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("History"),
            onTap: () {
              Navigator.pop(context);
              // Navigate to history page
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              // Navigate to profile page
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

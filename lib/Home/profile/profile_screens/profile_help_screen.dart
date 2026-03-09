import 'package:flutter/material.dart';

class ProfileHelpScreen extends StatefulWidget {
  const ProfileHelpScreen({super.key});

  @override
  State<ProfileHelpScreen> createState() => _ProfileHelpScreenState();
}

class _ProfileHelpScreenState extends State<ProfileHelpScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Center"),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: "FAQ"),
            Tab(text: "Contact Us"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          /// FAQ TAB
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                buildFAQ(
                  "How do I manage my notifications?",
                  "To manage notifications, go to Settings and select Notification Settings.",
                ),
                buildFAQ(
                  "How do I start calculations for free?",
                  "You can start calculations after signing up.",
                ),
                buildFAQ(
                  "How do I join a support group?",
                  "Go to the community section and join a support group.",
                ),
                buildFAQ(
                  "Is my data safe and private?",
                  "Yes, your data is protected and encrypted.",
                ),
              ],
            ),
          ),

          /// CONTACT TAB
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildContact(Icons.headphones, "Customer Services"),
                buildContact(Icons.chat, "WhatsApp"),
                buildContact(Icons.language, "Website"),
                buildContact(Icons.facebook, "Facebook"),
                buildContact(Icons.flutter_dash, "Twitter"),
                buildContact(Icons.camera_alt, "Instagram"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// FAQ WIDGET
  Widget buildFAQ(String question, String answer) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(answer),
          )
        ],
      ),
    );
  }

  /// CONTACT ITEM
  Widget buildContact(IconData icon, String title) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {},
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileSubscriptionScreen extends StatefulWidget {
  const ProfileSubscriptionScreen({super.key});

  @override
  State<ProfileSubscriptionScreen> createState() => _ProfileSubscriptionScreenState();
}

class _ProfileSubscriptionScreenState extends State<ProfileSubscriptionScreen> {
  bool isAnnual = true;

  Widget planCard({
    required String title,
    required String subtitle,
    required bool selected,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
        boxShadow: selected
            ? [
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1B3C8B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xff1B3C8B),
                    fontSize: 13,
                  ),
                )
              ],
            ),
          ),
          Radio(
            value: title,
            groupValue: isAnnual ? "Annual" : "Monthly",
            onChanged: (value) {
              setState(() {
                isAnnual = value == "Annual";
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              /// CLOSE BUTTON
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              const SizedBox(height: 5),

              /// TITLE
              const Text(
                "Get Premium",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1B3C8B),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Unlock all the power of this mobile tool and\n"
                "enjoy digital experience like never before!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              /// IMAGE
              Image.asset(
                "assets/subscription.png",
                height: 150,
              ),

              const SizedBox(height: 20),

              /// ANNUAL PLAN
              GestureDetector(
                onTap: () {
                  setState(() {
                    isAnnual = true;
                  });
                },
                child: planCard(
                  title: "Annual",
                  subtitle: "First 30 days free - Then 999/Year",
                  selected: isAnnual,
                  badge: "Best Value",
                ),
              ),

              /// MONTHLY PLAN
              GestureDetector(
                onTap: () {
                  setState(() {
                    isAnnual = false;
                  });
                },
                child: planCard(
                  title: "Monthly",
                  subtitle: "First 7 days free - Then 159/Month",
                  selected: !isAnnual,
                ),
              ),

             const SizedBox(height: 20),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1B3C8B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Start 7-day free trial",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// FOOTER TEXT
              const Text(
                "By placing this order, you agree to the Terms of Service "
                "and Privacy Policy. Subscription automatically renews "
                "unless auto-renew is turned off at least 24-hours before "
                "the end of the current period.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xff1B3C8B),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

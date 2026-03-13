import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileAboutScreen extends StatefulWidget {
  const ProfileAboutScreen({super.key});

  @override
  State<ProfileAboutScreen> createState() => _ProfileAboutScreenState();
}

Future<void> openWebsite() async {
  final Uri url = Uri.parse("https://www.techmayntra.com");

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

class _ProfileAboutScreenState extends State<ProfileAboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(fontWeight: FontWeight.bold),
          ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            Center(
              child: Image.asset(
                "assets/about.png",
                height: 200,
              ),
            ),

            const SizedBox(height: 25),

            /// TITLE
            const Text(
              "About SmartCalc",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            /// DESCRIPTION
            const Text(
              "Our Calculation App is designed to provide fast, accurate, and convenient financial and business calculations in one place. Whether you are a professional from a CA firm, banking sector, insurance industry, or an individual user, our app offers a wide range of tools including EMI, Income Tax, SIP, FD, RD, GST, IRR, XIRR, and more.",
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "If you need help or you have any questions, feel free to contact us by email.",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 10),

            /// EMAIL
            const Text(
              "smartcalctechmayntra715@gmail.com",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 35),

            /// COMPANY SECTION
            const Text(
              "Our Company",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LOGO + NAME
                 const Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/tm.png"),
                      ),
                       SizedBox(width: 15),
                       Text(
                        "TechMayntra IT Solutions ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// COMPANY DESCRIPTION
                  const Text(
                    "Techmayntra is an Information Technology and Service provider company. We have been building a website for over 14 years. It's our identity in IT-related business and services. We help global companies to entitle themselves and their business to the best innovative technological solutions that simplify their business through the use of Information technology. Our professional developers will provide a variety of skills from various backgrounds, a large pool of knowledge, and consulting experience it will be needed to achieve your business goals.We promote innovation, excellence, and the implementation of ethical business strategies. Our technological expertise and reputation for delivering high-quality solutions ensure our clients' success.",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 15),

                  
                  
                  const SizedBox(height: 15),

                  /// ADDRESS
                  const Text(
                    "Address",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "715, J B Tower, Opp Doordarshan kendra, Thaltej, Ahmedabad, Gujarat, India - 380054",
                  ),

                  const SizedBox(height: 12),

                  /// CONTACT
                  const Text(
                    "Contact",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text("Email: info@techmayntra.com"),
                  const Text("Phone: +91 7984400506"),

                  const SizedBox(height: 12),

                  /// WEBSITE
                  const Text(
                    "Website",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                   GestureDetector(
                    onTap: openWebsite,
                     child: const Text(
                      "www.techmayntra.com",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                                       ),
                   ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

import 'package:calculator/Home/OtpAuthentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  String mobileNumber = "";

  void onNumberTap(String number) {
    if (mobileNumber.length < 10) {
      setState(() {
        mobileNumber += number;
      });
    }
  }

  void onBackspace() {
    if (mobileNumber.isNotEmpty) {
      setState(() {
        mobileNumber =
            mobileNumber.substring(0, mobileNumber.length - 1);
      });
    }
  }

  Widget buildKey(String text, {VoidCallback? onTap, Color? backgroundColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
           color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 3),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
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

            // TITLE
            const Text(
              "Enter Your Mobile Number",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // MOBILE NO + INPUT (LEFT ALIGNED)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Mobile No.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "🇮🇳 +91",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          mobileNumber,
                          style: const TextStyle(
                            fontSize: 18,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


             const SizedBox(height: 150),


            const Text( 'or continue with' ,
              style: TextStyle(
                fontSize: 14,
               color: Colors.grey
              ),
            ),

            const SizedBox(height: 5),

            // GOOGLE BUTTON
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.g_mobiledata,
              size: 34,
              color: Colors.white,),
              label: const Text("Continue with Google",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white
              ),
          ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(280, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // FACEBOOK BUTTON
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.facebook,
              size: 24,
              color: Colors.white,),
              label: const Text("Continue with Facebook",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white
              ),
          ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size(280, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
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
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["⌫", "0", "->"],
      ])
        Row(
          children: row.map((e) {
            if (e == "⌫") {
              return Expanded(
                child: buildKey(
                  e,
                  onTap: onBackspace,
                ),
              );
            } 
            else if (e == "->") {
              return Expanded(
                child: buildKey(
                  e,
                  backgroundColor: Colors.blue[300],
                 onTap: () {
  if (mobileNumber.length == 10) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            OtpAuthentication(mobileNumber: mobileNumber),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter 10 digit mobile number"),
      ),
    );
  }
},

                ),
              );
            } 
            else {
              return Expanded(
                child: buildKey(
                  e,
                  onTap: () => onNumberTap(e),
                ),
              );
            }
          }).toList(),
        ),
    ],
  ),
),


            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

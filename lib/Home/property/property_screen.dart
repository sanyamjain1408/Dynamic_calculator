import 'package:calculator/Home/property/property_files/property_electricity_screen.dart';
import 'package:calculator/Home/property/property_files/property_landunit_screen.dart';
import 'package:calculator/Home/property/property_files/property_paintcost_screen.dart';
import 'package:flutter/material.dart';

class PropertyScreen extends StatefulWidget {
  const PropertyScreen({super.key});

  @override
  State<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {

  
final List<Map<String, dynamic>> items = [
    {
      "title": "Land Unit\nCalculator",
      "image": "assets/landunit_picture.png",
      "screen": const PropertyLandUnitScreen(),
    },
    {
      "title": "Paint Cost\nCalculator",
      "image": "assets/paintcost_picture.png",
      "screen": const PropertyPaintcostScreen(),
    },
    {
      "title": "Electricity Bill\nCalculator",
      "image": "assets/electricity_picture.png",
      "screen": const PropertyElectricityScreen(),
    },
    
  ];

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        title: const Text(
          "Property & Utility",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 40,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => item["screen"],
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      height: 81,
                      width: 81,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Image.asset(
                          item["image"],
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}




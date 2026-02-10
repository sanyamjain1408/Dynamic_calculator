import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '0';

  void onButtonTap(String value) {
    setState(() {
      if (value == 'AC') {
        input = '';
        result = '0';
      } 
      else if (value == '⌫') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } 
      else if (value == '=') {
        try {
          result = calculate(input).toString();
        } catch (e) {
          result = 'Error';
        }
      } 
      else {
        input += value;
      }
    });
  }

  double calculate(String exp) {
    exp = exp.replaceAll('×', '*').replaceAll('÷', '/');
    final List<String> tokens =
        RegExp(r'(\d+\.?\d*|[+\-*/])').allMatches(exp).map((m) => m.group(0)!).toList();

    double res = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String op = tokens[i];
      double num = double.parse(tokens[i + 1]);

      if (op == '+') res += num;
      if (op == '-') res -= num;
      if (op == '*') res *= num;
      if (op == '/') res /= num;
    }
    return res;
  }

  Widget buildButton(String text,
      {Color bg = Colors.white, Color txt = Colors.blue}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onButtonTap(text),
        child: Container(
          margin: const EdgeInsets.all(8),
          height: 60,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 22, color: txt),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffe8f0ff),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// Display
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(input,
                    style: const TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 10),
                Text(result,
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          /// Buttons
          Row(children: [
            buildButton('AC', txt: Colors.grey),
            buildButton('⌫'),
            buildButton('÷', bg: Colors.lightBlue.shade100),
            buildButton('×', bg: Colors.lightBlue.shade100),
          ]),
          Row(children: [
            buildButton('7'),
            buildButton('8'),
            buildButton('9'),
            buildButton('-', bg: Colors.lightBlue.shade100),
          ]),
          Row(children: [
            buildButton('4'),
            buildButton('5'),
            buildButton('6'),
            buildButton('+', bg: Colors.lightBlue.shade100),
          ]),
          Row(children: [
            buildButton('1'),
            buildButton('2'),
            buildButton('3'),
            buildButton('=', bg: Colors.blue, txt: Colors.white),
          ]),
          Row(children: [
            Expanded(
              flex: 2,
              child: buildButton('0'),
            ),
            buildButton('.'),
          ]),
        ],
      ),
    );
  }
}

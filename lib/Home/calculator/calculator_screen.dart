import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '0';
  bool isResultShown = false;

  void onButtonTap(String value) {
    setState(() {
      if (value == 'AC') {
        input = '';
        result = '0';
      } else if (value == '⌫') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == '=') {
        try {
          double calcResult = calculate(input);

          final formatter = NumberFormat('#,##,###.##', 'en_IN');
          result = formatter.format(calcResult);
          isResultShown = true;
        } catch (e) {
          result = 'Error';
        }
      } else {
        //  YEH YAHA LIKHNA HAI (sabse upar)
        if (isResultShown) {
          input = result; // result ko input bana do
          isResultShown = false;
        }
        List<String> operators = ['+', '-', '×', '÷'];

        if (operators.contains(value)) {
          // First character operator na ho
          if (input.isEmpty) return;

          // Replace last operator
          if (operators.contains(input[input.length - 1])) {
            input = input.substring(0, input.length - 1);
          }

          input += value;
        } else {
          // Agar number ya dot hai
          input += value;

          // Last number ko format karo
          List<String> parts = input.split(RegExp(r'([+\-×÷])'));

          String lastPart = parts.last;

          if (double.tryParse(lastPart.replaceAll(',', '')) != null) {
            final formatter = NumberFormat('#,##,###', 'en_IN');

            String formatted = formatter.format(
              double.parse(lastPart.replaceAll(',', '')),
            );

            input =
                input.substring(0, input.length - lastPart.length) + formatted;
          }
        }
      }
    });
  }

  double calculate(String exp) {
    exp = exp.replaceAll(',', '');
    exp = exp.replaceAll('×', '*').replaceAll('÷', '/');
    final List<String> tokens = RegExp(r'(\d+\.?\d*|[+\-*/])')
        .allMatches(exp)
        .map((m) => m.group(0)!)
        .toList();

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

  String formatInputNumber(String text) {
    if (text.isEmpty) return '';

    // comma remove karo pehle
    String clean = text.replaceAll(',', '');

    // agar number nahi hai to return original
    if (double.tryParse(clean) == null) return text;

    final formatter = NumberFormat('#,##,###', 'en_IN');
    return formatter.format(double.parse(clean));
  }

  Widget buildButton(String text,
      {Color bg = Colors.white, Color txt = Colors.blue}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onButtonTap(text),
        child: Container(
          margin: const EdgeInsets.all(8),
          height: 70,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 28, color: txt),
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
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input,
                      style: const TextStyle(fontSize: 30, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text(result,
                      style: const TextStyle(
                          fontSize: 46, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          /// Buttons
          Row(children: [
            buildButton(
              'AC',
              txt: Colors.black,
            ),
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

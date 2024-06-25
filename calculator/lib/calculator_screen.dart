import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = "0";
  String expression = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    displayText,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onButtonTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onButtonTap(String value) {
    setState(() {
      if (value == Btn.clr) {
        displayText = "0";
        expression = "";
      } else if (value == Btn.del) {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
          displayText = expression.isNotEmpty ? expression : "0";
        }
      } else if (value == Btn.calculate) {
        try {
          displayText = calculateExpression(expression);
          expression = displayText;
        } catch (e) {
          displayText = "Error";
        }
      } else {
        if (displayText == "0" && value != Btn.dot) {
          displayText = value;
        } else {
          displayText += value;
        }
        expression += value;
      }
    });
  }

  String calculateExpression(String expr) {
    try {
      expr = expr.replaceAll('×', '*');
      expr = expr.replaceAll('÷', '/');

      final evaluator = const ExpressionEvaluator();
      final exp = Expression.parse(expr);
      final result = evaluator.eval(exp, {});

      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  Color getBtnColor(String value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.substract,
            Btn.divided,
            Btn.calculate,
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}

class Btn {
  static const String n0 = '0';
  static const String n1 = '1';
  static const String n2 = '2';
  static const String n3 = '3';
  static const String n4 = '4';
  static const String n5 = '5';
  static const String n6 = '6';
  static const String n7 = '7';
  static const String n8 = '8';
  static const String n9 = '9';
  static const String dot = '.';
  static const String add = '+';
  static const String substract = '-';
  static const String multiply = '×';
  static const String divided = '÷';
  static const String per = '%';
  static const String del = 'DEL';
  static const String clr = 'CLR';
  static const String calculate = '=';

  static const List<String> buttonValues = [
    n7,
    n8,
    n9,
    divided,
    n4,
    n5,
    n6,
    multiply,
    n1,
    n2,
    n3,
    substract,
    dot,
    n0,
    add,
    per,
    clr,
    del,
    calculate
  ];
}

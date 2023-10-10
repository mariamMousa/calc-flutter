// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:mariam_first_project/buttons_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String n1 = ""; //.0-9
  String operand = ""; //+ - * /
  String n2 = ""; //.0-9
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          //output
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$n1$operand$n2".isEmpty ? "0" : "$n1$operand$n2",
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),

          //buttons
          Wrap(
            children: Btn.buttonValues
                .map(
                  (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : screenSize.width / 4,
                      height: screenSize.width / 5,
                      child: buildButtons(value)),
                )
                .toList(),
          )
        ]),
      ),
    );
  }

  Widget buildButtons(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(100)),
        child: InkWell(
            onTap: () => onBtnTap(value),
            child: Center(
                child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ))),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertToPercentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }
    appendValue(value);
  }

  void calculate() {
    if (n1.isEmpty) return;
    if (operand.isEmpty) return;
    if (n2.isEmpty) return;
    final double num1 = double.parse(n1);
    final double num2 = double.parse(n2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      n1 = "$result";

      if (n1.endsWith(".0")) {
        n1 = n1.substring(0, n1.length - 2);
      }
      operand = "";
      n2 = "";
    });
  }

  void convertToPercentage() {
    if (n1.isNotEmpty && operand.isNotEmpty && n2.isNotEmpty) {}
    calculate();
    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(n1);
    setState(() {
      n1 = "${(number / 100)}";
      operand = "";
      n2 = "";
    });
  }

  void clearAll() {
    setState(() {
      n1 = "";
      operand = "";
      n2 = "";
    });
  }

  void delete() {
    if (n2.isNotEmpty) {
      n2 = n2.substring(0, n2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (n1.isNotEmpty) {
      n1 = n1.substring(0, n1.length - 1);
    }
    setState(() {});
  }

  void appendValue(String value) {
    //if is operand and not "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      // operand pressed
      if (operand.isNotEmpty && n2.isNotEmpty) {
        calculate();
      }
      operand = value;
    }
    // assign value to n1 variable
    else if (n1.isEmpty || operand.isEmpty) {
      //check if value is "." | ex: n1=1.2
      if (value == Btn.dot && n1.contains(Btn.dot)) return;
      //n1="" | "0"
      if (value == Btn.dot && (n1.isEmpty || n1 == Btn.dot)) {
        value = "0.";
      }
      n1 += value;
    }
    // assign value to n2 variable
    else if (n2.isEmpty || operand.isNotEmpty) {
      //check if value is "." | ex: n2=1.2
      if (value == Btn.dot && n2.contains(Btn.dot)) return;
      //n1="" | "0"
      if (value == Btn.dot && (n2.isEmpty || n2 == Btn.dot)) {
        value = "0.";
      }
      n2 += value;
    }
    setState(() {});
  }

  Color getBtnColor(value) {
    return [Btn.clr, Btn.del].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.calculate,
            Btn.divide,
            Btn.subtract
          ].contains(value)
            ? Colors.redAccent
            : Colors.black87;
  }
}

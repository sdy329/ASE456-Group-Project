import 'package:flutter/material.dart';

class Simple extends StatefulWidget {
  const Simple({Key? key}) : super(key: key);

  @override
  State<Simple> createState() => _Simple();
}

class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key,
      required this.child,
      required this.buttonColor,
      required this.textColor,
      required this.function})
      : super(key: key);

  final String child;
  final buttonColor, textColor, function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              height: 10,
              width: 10,
              color: buttonColor,
              child: Center(
                child: Text(child,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: 20)),
              )),
        ),
      ),
    );
  }
}

class _Simple extends State<Simple> {
  String display = '0';
  double num1 = 0.0;
  double num2 = 0.0; // Initialize to a default value
  String operation = ''; // Initialize to an empty string
  double answer = 0.0;

  void clear() {
    setState(() {
      display = '0';
      num1 = 0.0;
      num2 = 0.0;
      operation = '';
      answer = 0.0;
    });
  }

  void handleClick(String input) {
    if (RegExp(r'[+\-*/0]').hasMatch(input)) {
      handleOperation(input);
    } else if (input == 'C') {
      clear();
    } else if (input == '=') {
      calculate();
    } else {
      setState(() {
        if (answer != 0 || RegExp(r'[+\-*/0]').hasMatch(display)) {
          display = input;
          answer = 0;
        } else {
          display += input;
        }

        if (operation.isNotEmpty) {
          num2 = double.parse(display);
        }
      });
    }
  }

  void handleOperation(String op) {
    setState(() {
      if (num1 == 0.0) {
        num1 = double.parse(display);
      }
      operation = op;
      display = op.toString();
    });
  }

  void calculate() {
    double result = 0.0; // Initialize result

    if (num1 != 0.0 && num2 != 0.0 && operation.isNotEmpty) {
      switch (operation) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          if (num2 != 0) {
            result = num1 / num2;
          } else {
            result = double.infinity;
          }
          break;
      }
      setState(() {
        display = result.toString();
        num1 = 0.0;
        num2 = 0.0;
        operation = '';
        answer = result;
      });
    }
  }

  final List buttons = [
    'C', // buttons[0]
    '', // buttons[1]
    '', // buttons[2]
    '/', // buttons[3]
    '9', // buttons[4]
    '8', // buttons[5]
    '7', // buttons[6]
    '*', // buttons[7]
    '6', // buttons[8]
    '5', // buttons[9]
    '4', // buttons[10]
    '-', // buttons[11]
    '3', // buttons[12]
    '2', // buttons[13]
    '1', // buttons[14]
    '+', // buttons[15]
    '0', // buttons[16]
    '.', // buttons[17]
    '', // buttons[18]
    '=', // buttons[19]
  ];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          height: height / 4,
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(16.0),
          child: Text(
            display,
            style: TextStyle(fontSize: 36),
          ),
        ),
        Container(
            height: height / 2,
            child: GridView.builder(
                itemCount: buttons.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio:
                      ((width / 4) / ((height / 2) / (buttons.length / 4))),
                ),
                itemBuilder: (context, index) {
                  return MyButton(
                    child: buttons[index],
                    buttonColor: Colors.deepPurple[100],
                    textColor: Colors.black,
                    function: () {
                      handleClick(buttons[index]);
                    },
                  );
                })),
      ],
    );
  }
}
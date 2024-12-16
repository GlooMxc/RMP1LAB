import 'package:flutter/material.dart';
import 'package:mobileprojects/button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; //.0-9
  String operator = ""; //+ - * / **
  String number2 = ""; //.0-9

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
                    "$number1$operator$number2".isEmpty
                        ? "0"
                        : "$number1$operator$number2",
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
              children: Btn.buttonValues.map((value) {
                if (value == Btn.calculate) {
                  return SizedBox(
                    width: screenSize.width,
                    height: screenSize.width / 5,
                    child: buildButton(value),
                  );
                }
                return SizedBox(
                  width: screenSize.width / 4,
                  height: screenSize.width / 5,
                  child: buildButton(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.white24),
          borderRadius: BorderRadius.circular(100)
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
              child: Text(
                  value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:30,
                  ),
              ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if(value==Btn.del){
      delete();
      return;
    }

    if(value==Btn.clr) {
      clearAll();
      return;
    }


    if(value==Btn.per){
      convertToPercentage();
      return;
    }

    if(value==Btn.calculate){
      calculateResult();
      return;
    }

    appendValue(value);
  }


  void calculateResult() {
    if(number1.isEmpty) return;
    if(operator.isEmpty) return;
    if(number2.isEmpty) return;

    final double num1=double.parse(number1);
    final double num2=double.parse(number2);

    var result = 0.0;

    switch(operator){
      case Btn.add:
        result = num1+num2;
        break;
      case Btn.subtract:
        result = num1-num2;
        break;
      case Btn.multiply:
        result = num1*num2;
        break;
      case Btn.divide:
        if (num2 == 0) {
          _showErrorMessage("Ошибка: Деление на ноль");
          return;
        }
        result = num1/num2;
        break;
      case Btn.exponent:
        result = cstPow(num1,num2.toInt());
        break;
      default:
        break;
    }
    setState(() {
        number1 = "$result";
        if (number1.endsWith(".0")) {
          number1 = number1.substring(0, number1.length - 2);
        }
      operator = "";
      number2 = "";
    });
  }

  double cstPow(double base,int exponent){
    double result=1.0;
    for (int i = 0; i < exponent; i++) {
      result *=base;
    }
    return exponent < 0 ? 1 / result : result;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void clearAll() {
    setState(() {
      number1="";
      operator="";
      number2="";
    });
  }

  void convertToPercentage() {
    if(number1.isNotEmpty&&operator.isNotEmpty&&number2.isNotEmpty){
      calculateResult();
    }

    if(operator.isNotEmpty){
      return;
    }

    final number = double.parse(number1);
    setState((){
      number1="${(number/100)}";
      operator = "";
      number2 = "";
    });
  }

  void delete() {
    if(number2.isNotEmpty){
      number2=number2.substring(0, number2.length-1);
    }else if(operator.isNotEmpty){
      operator = "";
    }else if(number1.isNotEmpty){
      number1 = number1.substring(0, number1.length-1);
    }

    setState(() {});
  }

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operator.isNotEmpty && number2.isNotEmpty) {
        calculateResult();
      }
      operator = value;
    }
    else if (number1.isEmpty || operator.isEmpty) {
      if (value == Btn.dot) {
        if (number1.isEmpty) {
          number1 = "0.";
        } else if (!number1.contains(Btn.dot)) {
          number1 += value;
        }
      } else {
        if (number1 == "0" && value != Btn.dot) {
          number1 = value;
        } else {
          number1 += value;
        }
      }
    }
    else if (number2.isEmpty || operator.isNotEmpty) {
      if (value == Btn.dot) {
        if (number2.isEmpty) {
          number2 = "0.";
        } else if (!number2.contains(Btn.dot)) {
          number2 += value;
        }
      } else {
        if (number2 == "0" && value != Btn.dot) {
          number2 = value;
        } else {
          number2 += value;
        }
      }
    }

    setState(() {});
  }

  Color getBtnColor(value) {
    return [Btn.del,Btn.clr].contains(value)
        ?Colors.blueGrey
        :[
      Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.exponent,
      Btn.calculate,
    ].contains(value)
        ?Colors.orange
        :Colors.black87;
  }
}




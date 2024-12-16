import 'package:flutter/material.dart';
import 'package:mobileprojects/calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multitask app',
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

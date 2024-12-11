//IM/2021/032-G.D.N.Gamage
import 'package:flutter/material.dart';
import 'Screens/calculator_screen.dart'; 

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calculator",
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      home: const CalculatorScreen(), // Use the CalculatorScreen widget
    );
  }
}
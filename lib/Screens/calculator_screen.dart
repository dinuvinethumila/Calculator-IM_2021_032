//IM/2021/032-G.D.N.Gamage
import 'package:flutter/material.dart';
import 'dart:math'; // 
import '../utils/calculator_logic.dart'; 

// The entry point of the screen 
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = ""; // Stores the user input.
  String result = "0"; // Stores the calculated result, initialized to "0".

  @override
  Widget build(BuildContext context) {
    // Determine screen width for dynamic button sizing based on device size.
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth > 600 ? 80.0 : 60.0;

    return Scaffold(
      // App bar at the top with the title of the calculator.
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Buttons align to the bottom.
        children: [
          // Display area for the input (top of the calculator screen).
         Container(
     alignment: Alignment.centerRight, // Align text to the right.
       padding: const EdgeInsets.all(20), // Add padding around the text.
       child: Text(
    input, // Display the user input.
    style: const TextStyle(
      fontSize: 24, // Set the font size for input text.
      color: Colors.white, // Set the text color to white.
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis, // Trim text if it overflows.
  ),
),


          // Display area for the result (below the input).
          Container(
            alignment: Alignment.centerRight, // Align result to the right.
            padding: const EdgeInsets.all(20), // Add padding around the text.
            child: Text(
              result, // Display the calculation result.
              style: const TextStyle(
                fontSize: 32, // Larger font size for the result.
                fontWeight: FontWeight.bold, // Make result bold for emphasis.
                color: Colors.white, // Color the result text blue.
              ),
            ),
          ),

          const Divider(thickness: 1), // Divider line between display and buttons.

          // Button rows for calculator functionalities.
          buildButtonRow(["C", "⌫"], buttonSize), 
          buildButtonRow(["(", ")", "√", "%"], buttonSize),
          buildButtonRow(["7", "8", "9", "/"], buttonSize), 
          buildButtonRow(["4", "5", "6", "*"], buttonSize), 
          buildButtonRow(["1", "2", "3", "-"], buttonSize), 
          buildButtonRow([".", "0", "=", "+"], buttonSize), 
        ],
      ),
    );
  }

  // Function to build a row of buttons with the specified labels and sizes.
 Widget buildButtonRow(List<String> buttons, double buttonSize) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute buttons evenly.
    children: buttons.map((btn) {
      // Determine the button color based on the type of button.
      Color buttonColor;
      if (RegExp(r'^[0-9.]$').hasMatch(btn)) {
        // Numbers and decimal point buttons.
        buttonColor = const Color.fromARGB(255, 84, 80, 80);
      } else if (btn == "C" || btn == "⌫") {
        // Clear and backspace buttons.
        buttonColor = const Color.fromARGB(255, 159, 157, 157);
      } else {
        // Operator and special symbol buttons.
        buttonColor = const Color.fromARGB(255, 255, 193, 37);
      }

      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4.0), // Space between buttons.
          child: ElevatedButton(
            // Triggered when a button is pressed.
            onPressed: () => buttonPressed(btn),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(buttonSize, buttonSize), // Set button dimensions.
              backgroundColor: buttonColor, // Set button background color.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners.
              ),
            ),
            child: Text(
              btn, // Display the button label.
              style: const TextStyle(
                fontSize: 20, // Set font size for the label.
                color: Colors.white, // Set the text color to white.
              ),
            ),
          ),
        ),
      );
    }).toList(), // Convert the list of buttons into widgets.
  );
}



  // Function called when any button is pressed.
  void buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        // Clear the input and result when "C" is pressed.
        input = "";
        result = "0";
      } else if (value == "⌫") {
        // Remove the last character when backspace is pressed.
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == "=") {
        // Calculate the result when "=" is pressed.
        calculate();
      } else if (value == "√") {
        // Calculate the square root when "√" is pressed.
        calculateSquareRoot();
      } else if (value == "%") {
        // Add percentage logic (e.g., divide by 100).
        input += input.isNotEmpty ? "/100" : "";
      } else {
        // Append the button value to the input string.
        input += value;
      }
    });
  }

  // Function to update the result by evaluating the input expression.
  void calculate() {
    try {
    double evalResult = evaluateExpression(input);
    result = evalResult.toStringAsFixed(2).replaceAll(".00", "");
  } catch (e) {
    result = e.toString().replaceAll("FormatException: ", ""); // Display "undefined" or other error messages
  }
  }

  // Function to calculate the square root of the input.
  void calculateSquareRoot() {
    try {
      // Convert the input to a number.
      double number = double.parse(input);
      if (number >= 0) {
        // Calculate square root for non-negative numbers and format the result.
        result = sqrt(number).toStringAsFixed(2).replaceAll(".00", "");
      } else {
        result = "invalid input";
      }
      input = ""; // Clear the input after calculation.
    } catch (e) {
      // Display Error for invalid input.
      result = "Error";
    }
  }
}

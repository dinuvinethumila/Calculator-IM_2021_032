//IM/2021/032-G.D.N.Gamage
import 'dart:math';


double evaluateExpression(String expression) {
  try {
    String sanitizedExpression = sanitizeExpression(expression);
    double result = evaluateWithBodmas(sanitizedExpression);
    if (result.isInfinite) {
      throw const FormatException("undefined");
    }
    if (result.isNaN) {
      throw const FormatException("undefined");
    }
    return result;
  } catch (e) {
    throw FormatException(e.toString());
  }
}


String sanitizeExpression(String expression) {
  expression = expression.replaceAll('÷', '/'); // Replace divide symbol
  expression = expression.replaceAll('%', '/100'); // Handle percentages
  expression = expression.replaceAllMapped(
    RegExp(r'√(\d+(\.\d+)?)'),
    (match) {
      double number = double.parse(match.group(1)!);
      if (number < 0) {
        throw const FormatException("undefined");
      }
      return sqrt(number).toString();
    },
  );
  return expression;
}

//BODMAS
double evaluateWithBodmas(String expression) {
  List<String> tokens = tokenize(expression);
  List<double> values = [];
  List<String> operators = [];

  for (String token in tokens) {
    if (isNumeric(token)) {
      values.add(double.parse(token)); // Parse numbers directly
    } else if (token == '(') {
      operators.add(token); // Push opening parenthesis
    } else if (token == ')') {
      // Evaluate until the matching opening parenthesis
      while (operators.isNotEmpty && operators.last != '(') {
        values.add(applyOperator(operators.removeLast(), values.removeLast(), values.removeLast()));
      }
      operators.removeLast(); // Remove the opening parenthesis
    } else if (isOperator(token)) {
      // Process based on operator precedence
      while (operators.isNotEmpty && precedence(operators.last) >= precedence(token)) {
        values.add(applyOperator(operators.removeLast(), values.removeLast(), values.removeLast()));
      }
      operators.add(token); // Add the current operator
    }
  }

  // Evaluate remaining operators
  while (operators.isNotEmpty) {
    values.add(applyOperator(operators.removeLast(), values.removeLast(), values.removeLast()));
  }

  return values.isNotEmpty ? values.last : 0; // Return the final result
}

// Tokenize the expression
List<String> tokenize(String expression) {
  RegExp regex = RegExp(r'(\d+\.\d+|\d+|[+\-*/%()])');
  return regex.allMatches(expression).map((match) => match.group(0)!).toList();
}

// Check if a string is numeric
bool isNumeric(String token) => double.tryParse(token) != null;

// Check if a string is an operator
bool isOperator(String token) => ['+', '-', '*', '/', '%'].contains(token);

// Operator precedence
int precedence(String operator) {
  if (operator == '+' || operator == '-') return 1; // Low precedence
  if (operator == '*' || operator == '/' || operator == '%') return 2; // High precedence
  return 0;
}

// Apply an operator to two numbers
double applyOperator(String operator, double b, double a) {
  switch (operator) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '*':
      return a * b;
    case '/':
      if (b == 0) {
        // Provide a specific "undefined" message for division by zero cases
        throw const FormatException("undefined");
      }
      return a / b;
    case '%':
      return a % b;
    default:
      throw FormatException("Invalid operator: $operator");
  }
}

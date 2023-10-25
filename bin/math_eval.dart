/*
 Требования:
 - поддержка операций: +, -, *, /
 - вложенные скобки
 - знак минус
*/

class MathExpression {
  final String _expression;

  MathExpression(String exp) : _expression = exp.replaceAll(' ', '');

  double eval(Map<String, dynamic> params) {
    ({String left, String operator, String right}) exp =
        _getOperands(_expression);
    return _calcExpression(exp.left, exp.operator, exp.right);
  }

  double _calcExpression(
    String leftOperand,
    String operator,
    String rightOperand,
  ) {
    double left = double.parse(leftOperand);
    double right = double.parse(rightOperand);
    return switch (operator)
    {
      '+' => left + right,
      '-' => left - right,
      '*' => left * right,
      '/' => left / right,
      _ => throw Exception(),
    };
  }

  bool _isOperator(String symbol) {
    return ['+', '-', '/', '*'].contains(symbol);
  }

  bool _isLowPriorityOperator(String symbol) {
    return ['+', '-'].contains(symbol);
  }

  ({String left, String operator, String right}) _getOperands(String exp) {
    String leftOperand = '';
    String operator = '';
    String rightOperand = '';

    int openedParenthesesCount = 0;
    for (int i = 0; i < exp.length; i++) {
      if (_isOperator(exp[i])) {
        if (openedParenthesesCount == 0) {
          leftOperand = exp.substring(0, i);
          operator = exp[i];
          rightOperand = exp.substring(i + 1);
          if (_isLowPriorityOperator(exp[i])) {
            break;
          }
        }
      } else if (exp[i] == '(') {
        openedParenthesesCount++;
      } else if (exp[i] == ')') {
        openedParenthesesCount--;
      }
    }
    return (left: leftOperand, operator: operator, right: rightOperand);
  }
}

class PrimitiveExpression {
  double calc() {
    return 0;
  }
}

void main() {
  Map<String, dynamic> params = {
    'x': 10,
  };
  MathExpression mathExpression = MathExpression('2+8');
  print(mathExpression.eval(params));
}

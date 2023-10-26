class MathExpression {
  final String _expression;

  MathExpression(String exp) : _expression = exp.replaceAll(' ', '');

  double eval(Map<String, dynamic> vars) {
    return _calc(_expression, vars);
  }

  double _calc(String exp, Map<String, dynamic> vars) {
    if (exp.length > 2 && exp.startsWith('(') && exp.endsWith(')')) {
      exp = exp.substring(1, exp.length - 1);
    }

    if (RegExp(r'^[a-zA-Z][\w_]*$').hasMatch(exp)) {
      exp = vars[exp].toString();
    }

    if (double.tryParse(exp) != null) {
      return double.parse(exp);
    }

    ({String left, String operator, String right}) splitExp = _getOperands(exp);
    double leftOperand = _calc(splitExp.left, vars);
    double rightOperand = _calc(splitExp.right, vars);

    return switch (splitExp.operator) {
      '+' => leftOperand + rightOperand,
      '-' => leftOperand - rightOperand,
      '*' => leftOperand * rightOperand,
      '/' => leftOperand / rightOperand,
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
      if (i == 0 && exp[i] == '-') {
        continue;
      } else if (_isOperator(exp[i])) {
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

void main() {
  List<({String exp, double res, Map<String, double> vars})> tests = [
    (exp: '10*5+4/2-1', res: 51, vars: {'x': 10}),
    (exp: '(x*3-5)/5', res: 5, vars: {'x': 10}),
    (exp: '3*x+15/(3+2)', res: 33, vars: {'x': 10}),
    (exp: '-2.5*((my_var+5)/(-2-1))', res: 12.5, vars: {'my_var': 10}),
  ];

  for (({String exp, double res, Map<String, double> vars}) test in tests) {
    MathExpression mathExpression = MathExpression(test.exp);
    print(mathExpression.eval(test.vars) == test.res);
  }
}

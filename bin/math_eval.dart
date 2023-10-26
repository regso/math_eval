class MathExpression {
  final String _expression;

  MathExpression(String exp) : _expression = exp.replaceAll(' ', '');

  double eval(Map<String, dynamic> params) {
    return _calc(_expression);
  }

  double _calc(String exp) {
    if (exp.length > 2 && exp.startsWith('(') && exp.endsWith(')')) {
      exp = exp.substring(1, exp.length - 1);
    }

    if (double.tryParse(exp) != null) {
      return double.parse(exp);
    }

    ({String left, String operator, String right}) splitExp = _getOperands(exp);
    double leftOperand = _calc(splitExp.left);
    double rightOperand = _calc(splitExp.right);

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

void main() {
  List<({String exp, double res, Map<String, double> params})> examples = [
    // (exp: '10*(5+4)/2-1', res: 51, params: {'x': 10}),
    (exp: '10*5+4/2-1', res: 51, params: {'x': 10}),
    // (expression: '(x*3-5)/5', result: '5', params: {'x': 10}),
    // (expression: '3*x+15/(3+2)', result: '33', params: {'x': 10}),
  ];
  for (({String exp, double res, Map<String, double> params}) example
      in examples) {
    MathExpression mathExpression = MathExpression(example.exp);
    print(mathExpression.eval(example.params));
  }
}

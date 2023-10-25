/*
 Требования:
 - поддержка операций: +, -, *, /
 - вложенные скобки
 - знак минус
*/

class MathExpression {
  final String _expression;

  MathExpression(String exp): _expression = exp.replaceAll(' ', '');

  double eval(Map<String, dynamic> params) {
    print(_getOperands(_expression));
    return _expression.isEmpty ? 0 : 1;
  }

  bool _isOperator(String symbol) {
    return ['+', '-', '/', '*'].contains(symbol);
  }

  bool _isLowPriorityOperator(String symbol) {
    return ['+', '-'].contains(symbol);
  }

  Record _getOperands(String exp) {
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
      } else if(exp[i] == '(') {
        openedParenthesesCount++;
      } else if (exp[i] == ')') {
        openedParenthesesCount--;
      }
    }
    return (left: leftOperand, operator: operator, right: rightOperand);
  }
}

void main() {
  MathExpression mathExpression = MathExpression('2-8/1*9+1'); // '10*5+4/2-1'
  Map<String, dynamic> params = {
    'x': 10,
  };
  mathExpression.eval(params);
}

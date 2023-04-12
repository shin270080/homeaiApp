import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  var _output = '0';
  var _currentNumber = '';
  var _operator = '';
  var _previousNumber = '';

  void _handleButtonClick(String buttonText) {
    setState(() {
      switch (buttonText) {
        case 'C':
          _output = '0';
          _currentNumber = '';
          _operator = '';
          _previousNumber = '';
          break;
        case '+/-':
          if (_currentNumber != '') {
            _currentNumber = (-double.parse(_currentNumber)).toString();
            _output = _currentNumber;
          }
          break;
        case '%':
          if (_currentNumber != '') {
            _currentNumber = (double.parse(_currentNumber) / 100).toString();
            _output = _currentNumber;
          }
          break;
        case '/':
        case '*':
        case '-':
        case '+':
          if (_operator != '' && _currentNumber != '') {
            _performOperation();
          }
          _operator = buttonText;
          _previousNumber = _currentNumber;
          _currentNumber = '';
          break;
        case '=':
          _performOperation();
          _operator = '';
          break;
        case '.':
          if (!_currentNumber.contains('.')) {
            _currentNumber += '.';
            _output = _currentNumber;
          }
          break;
        default:
          _currentNumber += buttonText;
          _output = _currentNumber;
      }
    });
  }

  void _performOperation() {
    switch (_operator) {
      case '/':
        _currentNumber = (double.parse(_previousNumber) / double.parse(_currentNumber)).toString();
        break;
      case '*':
        _currentNumber = (double.parse(_previousNumber) * double.parse(_currentNumber)).toString();
        break;
      case '-':
        _currentNumber = (double.parse(_previousNumber) - double.parse(_currentNumber)).toString();
        break;
      case '+':
        _currentNumber = (double.parse(_previousNumber) + double.parse(_currentNumber)).toString();
        break;
    }
    _output = _currentNumber;
    _previousNumber = '';
    _currentNumber = '';
  }

  Widget _buildButton(String buttonText, Color buttonColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _handleButtonClick(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: buttonColor,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            padding: EdgeInsets.all(16.0),
            shape: CircleBorder(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Text(
                _output,
              ),
            ),
          ),

          Row(
            children: <Widget>[
              _buildButton('C', Colors.red),
              _buildButton('+/-', Colors.black),
              _buildButton('%', Colors.black),
              _buildButton('/', Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('7', Colors.black),
              _buildButton('8', Colors.black),
              _buildButton('9', Colors.black),
              _buildButton('*', Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('4', Colors.black),
              _buildButton('5', Colors.black),
              _buildButton('6', Colors.black),
              _buildButton('-', Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('1', Colors.black),
              _buildButton('2', Colors.black),
              _buildButton('3', Colors.black),
              _buildButton('+', Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () => _handleButtonClick('0'),
                    child: Text(
                      '0',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      padding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                ),
              ),
              _buildButton('.', Colors.black),
              _buildButton('=', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}
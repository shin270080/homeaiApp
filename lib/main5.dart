import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mini Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MiniGamePage(),
    );
  }
}

class MiniGamePage extends StatefulWidget {
  @override
  _MiniGamePageState createState() => _MiniGamePageState();
}

class _MiniGamePageState extends State<MiniGamePage> {
  int _score = 0;
  int _targetNumber = 0;

  void _generateTargetNumber() {
    final random = Random();
    _targetNumber = random.nextInt(10) + 1;
  }

  void _incrementScore() {
    setState(() {
      _score++;
      _generateTargetNumber();
    });
  }

  @override
  void initState() {
    super.initState();
    _generateTargetNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Mini Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Score: $_score',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Text(
            'Target number: $_targetNumber',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_targetNumber % 2 == 0) {
                _incrementScore();
              } else {
                setState(() {
                  _score = 0;
                  _generateTargetNumber();
                });
              }
            },
            child: Text('Tap me'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mini Game',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _score = 0;
  bool _isGameOver = false;

  final Random _random = Random();
  late int _targetNumber;

  void _startGame() {
    _score = 0;
    _isGameOver = false;
    _generateTargetNumber();
  }

  void _generateTargetNumber() {
    _targetNumber = _random.nextInt(10) + 1;
  }

  void _checkAnswer(int number) {
    if (_isGameOver) return;

    if (number == _targetNumber) {
      _score++;
      _generateTargetNumber();
    } else {
      _isGameOver = true;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Mini Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Target Number: $_targetNumber',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            if (_isGameOver)
              Text(
                'Game Over',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
            if (!_isGameOver)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 1; i <= 10; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => _checkAnswer(i),
                        child: Text(
                          i.toString(),
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                ],
              ),
            if (_isGameOver)
              ElevatedButton(
                onPressed: _startGame,
                child: Text('Play Again'),
              ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(ColorfulNumberBlockTapGame());
}

class ColorfulNumberBlockTapGame extends StatefulWidget {
  @override
  _ColorfulNumberBlockTapGameState createState() =>
      _ColorfulNumberBlockTapGameState();
}

class _ColorfulNumberBlockTapGameState
    extends State<ColorfulNumberBlockTapGame> {
  int _score = 0;
  int _highScore = 0;
  int _seconds = 30;
  Timer? _timer;
  Random _random = Random();
  int _number = 1;
  Color _color = Colors.red;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _stopGame();
      }
    });
  }

  void _stopGame() {
    _timer?.cancel();
    if (_score > _highScore) {
      setState(() {
        _highScore = _score;
      });
    }
    setState(() {
      _score = 0;
      _seconds = 30;
      _number = 1;
      _color = Colors.red;
    });
  }

  void _startGame() {
    _stopGame();
    _startTimer();
    _generateNumber();
  }

  void _generateNumber() {
    setState(() {
      _number = _random.nextInt(9) + 1;
      _color = Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        1.0,
      );
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      if (_seconds > 0) {
        _generateNumber();
      }
    });
  }

  void _onTap() {
    if (_number == _score + 1) {
      setState(() {
        _score++;
        _number++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colorful Number Block Tap Game',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Colorful Number Block Tap Game'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Score: $_score'),
              Text('High Score: $_highScore'),
              Text('Time Left: $_seconds seconds'),
              SizedBox(height: 50),
              GestureDetector(
                onTap: _onTap,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '$_number',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: _startGame,
                child: Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

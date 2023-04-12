import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(ColorfulBallTapGame());
}

class ColorfulBallTapGame extends StatefulWidget {
  @override
  _ColorfulBallTapGameState createState() => _ColorfulBallTapGameState();
}

class _ColorfulBallTapGameState extends State<ColorfulBallTapGame> {
  int _score = 0;
  int _highScore = 0;
  int _seconds = 30;
  Timer? _timer;
  Random _random = Random();
  double _top = 0.0;
  double _left = 0.0;
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
      _top = 0.0;
      _left = 0.0;
      _color = Colors.red;
    });
  }

  void _startGame() {
    _stopGame();
    _startTimer();
    _moveBall();
  }

  void _moveBall() {
    setState(() {
      _top = _random.nextDouble() * 200;
      _left = _random.nextDouble() * 200;
      _color = Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        1.0,
      );
    });
    Future.delayed(Duration(milliseconds: 500), () {
      if (_seconds > 0) {
        _moveBall();
      }
    });
  }

  void _onTap() {
    setState(() {
      _score++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colorful Ball Tap Game',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Colorful Ball Tap Game'),
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
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.only(top: _top, left: _left),
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

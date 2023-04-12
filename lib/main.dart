import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(ColorfulNumberRandomMovingBlockTapGame());
}

class ColorfulNumberRandomMovingBlockTapGame extends StatefulWidget {
  @override
  _ColorfulNumberRandomMovingBlockTapGameState createState() =>
      _ColorfulNumberRandomMovingBlockTapGameState();
}

class _ColorfulNumberRandomMovingBlockTapGameState
    extends State<ColorfulNumberRandomMovingBlockTapGame> {
  int _score = 0;
  int _highScore = 0;
  int _seconds = 30;
  Timer? _timer;
  List<_Block> _blocks = [];
  Random _random = Random();

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
      _blocks = [];
    });
  }

  void _startGame() {
    _stopGame();
    _startTimer();
    _generateBlock();
  }

  void _generateBlock() {
    setState(() {
      _blocks.add(_Block(
        number: _random.nextInt(9) + 1,
        color: Color.fromRGBO(
          _random.nextInt(256),
          _random.nextInt(256),
          _random.nextInt(256),
          1.0,
        ),
        position: Offset(
          _random.nextDouble() * MediaQuery.of(context).size.width,
          _random.nextDouble() * MediaQuery.of(context).size.height,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 10,
          (_random.nextDouble() - 0.5) * 10,
        ),
      ));
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      if (_seconds > 0) {
        _generateBlock();
      }
    });
  }

  void _onTap(_Block block) {
    if (block.number == _score + 1) {
      setState(() {
        _score++;
        _blocks.remove(block);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colorful Number Random Moving Block Tap Game',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Colorful Number Random Moving Block Tap Game'),
        ),
        body: Stack(
          children: [
            for (var block in _blocks)
              Positioned(
                left: block.position.dx,
                top: block.position.dy,
                child: GestureDetector(
                  onTap: () => _onTap(block),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: block.color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${block.number}',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Score: $_score'),
                  Text('High Score: $_highScore'),
                  Text('Time Left: $_seconds seconds'),

                  ElevatedButton(
                    onPressed: () => _startGame(),
                    child: Text('Start Game'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class _Block {
  final int number;
  final Color color;
  Offset position;
  Offset velocity;

  _Block({
    required this.number,
    required this.color,
    required this.position,
    required this.velocity,
  });
}
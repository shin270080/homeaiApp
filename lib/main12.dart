import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(BlockBreaker());

class BlockBreaker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Breaker',
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _ballX = 0.0;
  double _ballY = 0.0;
  double _paddleX = 0.0;
  bool _gameStarted = false;
  int _score = 0;
  int _angle = 0;
  int _lives = 3;
  int _numRows = 5;
  int _numCols = 7;
  List<List<bool>> _blocks = [];
  late double _blockWidth;
  late double _blockHeight;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 16),
    )..addListener(() {
      if (_gameStarted) {
        setState(() {
          _ballX += _animation.value * cos(_angle);
          _ballY += _animation.value * sin(_angle);
          if (_ballX < -1.0 || _ballX > 1.0) {
            _angle = (pi - _angle) as int;
          }
          if (_ballY < -1.0) {
            _angle = -_angle;
          } else if (_ballY > 1.0) {
            _lives--;
            if (_lives == 0) {
              _gameOver();
            } else {
              _gameStarted = false;
              _ballX = 0.0;
              _ballY = -0.8;
              _paddleX = 0.0;
              _animation;
              _controller.reset();
            }
          } else if (_ballY > 0.8 && (_ballX < _paddleX - 0.2 || _ballX > _paddleX + 0.2)) {
            _angle = -_angle;
          } else if (_ballY > 0.8) {
            _angle = (pi - _angle) as int;
            _score++;
          }
          int row = ((_numRows - 1) * (_ballY + 1.0) / 2.0).floor();
          int col = ((_numCols - 1) * (_ballX + 1.0) / 2.0).floor();
          if (row >= 0 && row < _numRows && col >= 0 && col < _numCols && _blocks[row][col]) {
            _blocks[row][col] = false;
            _score++;
            _angle = -_angle;
          }
        });
      }
    });

    _animation = Tween<double>(begin: 0.01, end: 0.02).animate(_controller);

    _initializeBlocks();
  }

  void _initializeBlocks() {
    _blockWidth = 2.0 / _numCols;
    _blockHeight = 0.3;
    _blocks = List.generate(_numRows, (row) => List.generate(_numCols, (col) => true));

    _gameStarted = false;
    _ballX = 0.0;
    _ballY = -0.8;
    _paddleX = 0.0;
    _score = 0;
    _lives = 3;
    _blocks = List.generate(_numRows, (row) => List.generate(_numCols, (col) => true));
  }

  void _gameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Your score is $_score.'),
        actions: [
          TextButton(
            onPressed: () {
              _initializeBlocks();
              Navigator.of(context).pop();
            },
            child: Text('Restart'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _startGame() {
    if (!_gameStarted) {
      _gameStarted = true;
      _ballX = 0.0;
      _ballY = -0.8;
      _paddleX = 0.0;
      _animation = Tween<double>(begin: 0.01, end: 0.02).animate(_controller);
      _controller.repeat();
    }
  }

  void _movePaddle(double dx) {
    if (_gameStarted) {
      setState(() {
        _paddleX += dx;
        if (_paddleX < -0.9) {
          _paddleX = -0.9;
        }
        if (_paddleX > 0.9) {
          _paddleX = 0.9;
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Block Breaker'),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) => _movePaddle(details.delta.dx / 200),
        onTap: _startGame,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Score: $_score'),
                    Text('Lives: $_lives'),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: _numCols,
                    children: List.generate(
                      _numRows * _numCols,
                          (index) {
                        int row = index ~/ _numCols;
                        int col = index % _numCols;
                        return Padding(
                          padding: EdgeInsets.all(2),
                          child: _blocks[row][col] ? Container(color: Colors.blue) : SizedBox.shrink(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: (_ballX + 1) * MediaQuery.of(context).size.width / 2 - 15,
              top: (_ballY + 1) * MediaQuery.of(context).size.height / 2 - 15,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: (_paddleX + 1) * MediaQuery.of(context).size.width / 2 - 50,
              bottom: 20,
              child:

              Container(
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

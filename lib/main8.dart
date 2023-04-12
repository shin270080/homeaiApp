import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(ColorfulBlockMoveGame());
}

class ColorfulBlockMoveGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colorful Block Move Game',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int _blockCount = 3;
  static const double _blockSize = 80.0;
  static const double _targetSize = 100.0;
  static const int _roundDuration = 10;

  int _score = 0;
  int _round = 1;
  late int _targetIndex;
  List<int> _blockIndexes = List.generate(_blockCount, (index) => index);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startNewRound() {
    _targetIndex = Random().nextInt(_blockCount);
    _timer = Timer(Duration(seconds: _roundDuration), _onRoundEnd);
  }

  void _onRoundEnd() {
    _timer?.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Round $_round ended'),
        content: Text('Your score is $_score'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _score = 0;
                _round = 1;
              });
            },
            child: Text('Restart'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _score = 0;
                _round++;
                _startNewRound();
              });
            },
            child: Text('Next Round'),
          ),
        ],
      ),
    );
  }

  void _onBlockTap(int index) {
    if (index == _targetIndex) {
      setState(() {
        _score++;
        _round++;
        _startNewRound();
      });
    } else {
      _onRoundEnd();
    }
  }

  Widget _buildBlock(int index) {
    Color color = Color.fromRGBO(
      Random().nextInt(255),
      Random().nextInt(255),
      Random().nextInt(255),
      1,
    );
    return GestureDetector(
      onTap: () => _onBlockTap(index),
      child: Container(
        width: _blockSize,
        height: _blockSize,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(_blockSize / 2),
        ),
        child: Center(
          child: Text(
            '$index',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Colorful Block Move Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: _blockIndexes.map(_buildBlock).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Tap the block with the number $_targetIndex',
              style: TextStyle(fontSize:
              30),
            ),
            SizedBox(height: 16),
            Container(
              width: _targetSize,
              height: _targetSize,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(_targetSize / 2),
              ),
              child: Center(
                child: Text(
                  '$_targetIndex',
                  style: TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Round: $_round',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
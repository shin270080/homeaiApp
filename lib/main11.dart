import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(BallHitGame());

class BallHitGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ball Hit Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BallHit(),
    );
  }
}

class BallHit extends StatefulWidget {
  @override
  _BallHitState createState() => _BallHitState();
}

class _BallHitState extends State<BallHit> {
  int _score = 0;
  bool _ballVisible = true;

  void _hitBall() {
    setState(() {
      _score++;
      _ballVisible = false;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _ballVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ball Hit Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: _ballVisible,
              child: GestureDetector(
                onTap: _hitBall,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'Hit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
// ハエ叩きゲーム完成
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fly Swatter Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double _flyX = 0;
  double _flyY = 0;
  int _score = 0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _flyX = Random().nextInt(300).toDouble();
      _flyY = Random().nextInt(500).toDouble();
      _score += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fly Swatter Game'),
      ),
      body: Stack(
        children: [
          Positioned(
            left: _flyX,
            top: _flyY,
            child: GestureDetector(
              child: Icon(Icons.baby_changing_station_outlined, size: 50),
              onTapDown: _onTapDown,
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Text('Score: $_score', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}

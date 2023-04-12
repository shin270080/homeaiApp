import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(BlockGame());
}

class BlockGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Game',
      home: BlockScreen(),
    );
  }
}

class BlockScreen extends StatefulWidget {
  @override
  _BlockScreenState createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  int score = 0;
  double blockX = 0;
  double blockY = 0;

  void _updateScore() {
    setState(() {
      score++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          blockX = Random().nextDouble() * MediaQuery.of(context).size.width;
          blockY = Random().nextDouble() * MediaQuery.of(context).size.height;
          _updateScore();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Block Game'),
        ),
        body: Stack(
          children: [
            Positioned(
              left: blockX,
              top: blockY,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Text(
                'Score: $score',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

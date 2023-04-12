import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(BallGame());
}

class BallGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ball Game',
      home: BallScreen(),
    );
  }
}

class BallScreen extends StatefulWidget {
  @override
  _BallScreenState createState() => _BallScreenState();
}

class _BallScreenState extends State<BallScreen> {
  double ballX = 0;
  double ballY = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          ballX = Random().nextDouble() * MediaQuery.of(context).size.width;
          ballY = Random().nextDouble() * MediaQuery.of(context).size.height;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ball Game'),
        ),
        body: Stack(
          children: [
            Positioned(
              left: ballX,
              top: ballY,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

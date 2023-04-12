import 'package:flutter/material.dart';
import 'dart:math';
// ブロック崩しゲーム動かない
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Breaker Game',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Ball variables
  double ballPosX = 0;
  double ballPosY = 0;
  double ballSpeed = 3;
  double ballAngle = pi / 4;

  // Paddle variables
  double paddlePosX = 0;
  double paddleWidth = 100;

  // Block variables
  int rows = 5;
  int columns = 7;
  List<List<bool>> blocks = [];

  // Game variables
  int score = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    // Reset ball position and angle
    ballPosX = 0;
    ballPosY = 0;
    ballAngle = pi / 4;

    // Reset paddle position
    paddlePosX = 0;

    // Reset block state
    blocks = List.generate(rows, (i) => List.filled(columns, true));

    // Reset game state
    score = 0;
    gameOver = false;
  }

  void updateGame() {
    // Move ball
    ballPosX += ballSpeed * cos(ballAngle);
    ballPosY += ballSpeed * sin(ballAngle);

    // Check if ball hits wall
    if (ballPosX < -1 || ballPosX > 1) {
      ballAngle = pi - ballAngle;
    }
    if (ballPosY < -1) {
      ballAngle = -ballAngle;
    }

    // Check if ball hits paddle
    if (ballPosY > 0.8 && ballPosY < 0.9 &&
        ballPosX > paddlePosX - paddleWidth / 2 &&
        ballPosX < paddlePosX + paddleWidth / 2) {
      ballAngle = -ballAngle;
    }

    // Check if ball hits block
    int row = ((1 - ballPosY) / 0.2).floor();
    int col = ((ballPosX + 1) / (2 / columns)).floor();
    if (row >= 0 && row < rows && col >= 0 && col < columns &&
        blocks[row][col]) {
      blocks[row][col] = false;
      score++;
      if (score == rows * columns) {
        gameOver = true;
      }
      ballAngle = pi - ballAngle;
    }

    // Check if ball falls off screen
    if (ballPosY > 1) {
      gameOver = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Block Breaker Game'),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            paddlePosX += details.delta.dx / MediaQuery
                .of(context)
                .size
                .width;
            if (paddlePosX < -1 + paddleWidth / 2) {
              paddlePosX = -1 + paddleWidth / 2;
            }
            if (paddlePosX > 1 - paddleWidth / 2) {
              paddlePosX =
                  1 - paddleWidth / 2;
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Stack(
            children: [
// Ball
              Positioned(
                top: (ballPosY + 1) * MediaQuery
                    .of(context)
                    .size
                    .height / 2,
                left: (ballPosX + 1) * MediaQuery
                    .of(context)
                    .size
                    .width / 2,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              // Paddle
              Positioned(
                bottom: 0,
                left: (paddlePosX + 1) * MediaQuery
                    .of(context)
                    .size
                    .width / 2 - paddleWidth / 2,
                child: Container(
                  width: paddleWidth,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              // Blocks
              for (int i = 0; i < rows; i++)
                for (int j = 0; j < columns; j++)
                  if (blocks[i][j])
                    Positioned(
                      top: ((-0.9 - i * 0.2) + 1) * MediaQuery
                          .of(context)
                          .size
                          .height / 2,
                      left: ((-1 + j * 2 / columns) + 1) * MediaQuery
                          .of(context)
                          .size
                          .width / 2,
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / columns,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.primaries[(i * columns + j) %
                              Colors.primaries.length],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

              // Game Over
              if (gameOver)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Game Over',
                        style: TextStyle(fontSize: 32),
                      ),
                      ElevatedButton(
                        onPressed: resetGame,
                        child: Text('Play Again'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
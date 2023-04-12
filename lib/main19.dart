import 'package:flutter/material.dart';
import 'dart:math';

// ブロック崩しゲーム　少し動く
void main() => runApp(BrickBreaker());

class BrickBreaker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brick Breaker',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Brick Breaker'),
        ),
        body: BrickBreakerGame(),
      ),
    );
  }
}

class BrickBreakerGame extends StatefulWidget {
  @override
  _BrickBreakerGameState createState() => _BrickBreakerGameState();
}

class _BrickBreakerGameState extends State<BrickBreakerGame>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  double ballDiameter = 50.0;
  double ballX = 0.0;
  double ballY = 0.0;
  double ballVelocityX = 1.0;
  double ballVelocityY = 1.0;
  double paddleWidth = 150.0;
  double paddleHeight = 30.0;
  double paddleX = 0.0;
  double paddleY = 0.0;
  double brickWidth = 70.0;
  double brickHeight = 30.0;
  int numRows = 5;
  int numCols = 5;
  List<List<bool>> bricks = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < numRows; i++) {
      bricks.add(List.generate(numCols, (index) => true));
    }

    controller = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );

    controller.addListener(() {
      setState(() {
        ballX += ballVelocityX;
        ballY += ballVelocityY;
        paddleX = (MediaQuery.of(context).size.width - paddleWidth) / 2;
        paddleY = MediaQuery.of(context).size.height - (paddleHeight * 2);

        if (ballX < 0 || ballX > (MediaQuery.of(context).size.width - ballDiameter)) {
          ballVelocityX = -ballVelocityX;
        }

        if (ballY < 0) {
          ballVelocityY = -ballVelocityY;
        }

        if (ballY > (MediaQuery.of(context).size.height - ballDiameter)) {
          controller.stop();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Game Over'),
              content: Text('You Lose!'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      ballX = 0.0;
                      ballY = 0.0;
                      ballVelocityX = 1.0;
                      ballVelocityY = 1.0;

                      for (var i = 0; i < numRows; i++) {
                        bricks[i] = List.generate(numCols, (index) => true);
                      }
                    });
                    controller.repeat();
                  },
                  child: Text('Play Again'),
                ),
              ],
            ),
          );
        }

        if (ballX + ballDiameter > paddleX &&
            ballX < paddleX +

                paddleWidth &&
            ballY + ballDiameter > paddleY &&
            ballY < paddleY + paddleHeight) {
          ballVelocityY = -ballVelocityY;
        }
        for (var i = 0; i < numRows; i++) {
          for (var j = 0; j < numCols; j++) {
            if (bricks[i][j] &&
                ballX + ballDiameter > j * brickWidth &&
                ballX < (j + 1) * brickWidth &&
                ballY + ballDiameter > i * brickHeight &&
                ballY < (i + 1) * brickHeight) {
              ballVelocityY = -ballVelocityY;
              bricks[i][j] = false;
            }
          }
        }

        if (bricks.every((row) => row.every((val) => !val))) {
          controller.stop();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Congratulations'),
              content: Text('You Won!'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      ballX = 0.0;
                      ballY = 0.0;
                      ballVelocityX = 1.0;
                      ballVelocityY = 1.0;

                      for (var i = 0; i < numRows; i++) {
                        bricks[i] = List.generate(numCols, (index) => true);
                      }
                    });
                    controller.repeat();
                  },
                  child: Text('Play Again'),
                ),
              ],
            ),
          );
        }
      });
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          paddleX += details.delta.dx;

          if (paddleX < 0) {
            paddleX = 0;
          } else if (paddleX > MediaQuery.of(context).size.width - paddleWidth) {
            paddleX = MediaQuery.of(context).size.width - paddleWidth;
          }
        });
      },
      child: CustomPaint(
        painter: BrickBreakerPainter(
          ballX,
          ballY,
          ballDiameter,
          paddleWidth,
          paddleHeight,
          paddleX,
          paddleY,
          brickWidth,
          brickHeight,
          numRows,
          numCols,
          bricks,
        ),
      ),
    );
  }
}

class BrickBreakerPainter extends CustomPainter {
  double ballX;
  double ballY;
  double ballDiameter;
  double paddleWidth;
  double paddleHeight;
  double paddleX;
  double paddleY;
  double brickWidth;
  double brickHeight;
  int numRows;
  int numCols;
  List<List<bool>> bricks;

  BrickBreakerPainter(
      this.ballX,
      this.ballY,
      this.ballDiameter,
      this.paddleWidth,
      this.paddleHeight,
      this.paddleX,
      this.paddleY,
      this.brickWidth,
      this.brickHeight,
      this.numRows,
      this.numCols,
      this.bricks,
      );

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    // Draw ball
    paint.color = Colors.red;
    canvas.drawCircle(Offset(ballX, ballY), ballDiameter / 2, paint);

// Draw paddle
    paint.color = Colors.blue;
    canvas.drawRect(
        Rect.fromLTWH(paddleX, paddleY, paddleWidth, paddleHeight), paint);

// Draw bricks
    paint.color = Colors.green;
    for (int i = 0; i < numRows; i++) {
      for (var j = 0; j < numCols; j++) {
        if (bricks[i][j]) {
          canvas.drawRect(
              Rect.fromLTWH(j * brickWidth, i * brickHeight, brickWidth, brickHeight),
              paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
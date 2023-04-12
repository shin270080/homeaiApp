import 'dart:math';
import 'package:flutter/material.dart';
// colorful block destroy game ok
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colorful Block Destroy Game',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Colorful Block Destroy Game'),
        ),
        body: GameBoard(),
      ),
    );
  }
}

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final int rows = 5;
  final int cols = 8;
  final List<Color> colors = [    Colors.red,    Colors.green,    Colors.blue,    Colors.yellow,    Colors.purple,    Colors.orange,  ];
  List<List<Color>> board = [];

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

  void initializeBoard() {
    Random random = Random();
    for (int row = 0; row < rows; row++) {
      List<Color> rowColors = [];
      for (int col = 0; col < cols; col++) {
        rowColors.add(colors[random.nextInt(colors.length)]);
      }
      board.add(rowColors);
    }
  }

  void onTap(int row, int col) {
    setState(() {
      board[row][col] = Colors.white;
    });
  }

  bool checkGameOver() {
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (board[row][col] != Colors.white) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
          ),
          itemBuilder: (BuildContext context, int index) {
            int row = index ~/ cols;
            int col = index % cols;
            return GestureDetector(
              onTap: () {
                onTap(row, col);
                if (checkGameOver()) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Game Over'),
                        content: Text('Congratulations, you won!'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                color: board[row][col],
                margin: EdgeInsets.all(2),
              ),
            );
          },
          itemCount: rows * cols,
        ),
      ],
    );
  }
}

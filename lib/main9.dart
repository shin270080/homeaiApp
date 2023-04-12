import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(ColorfulBlockGame());

class ColorfulBlockGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colorful Block Game',
      home: Scaffold(
        body: SafeArea(
          child: Game(),
        ),
      ),
    );
  }
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final int rows = 5;
  final int columns = 6;
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  late List<List<Color>> blocks;

  @override
  void initState() {
    super.initState();
    generateBlocks();
  }

  void generateBlocks() {
    blocks = List.generate(rows, (i) => List.generate(columns, (j) => colors[Random().nextInt(colors.length)]));
  }

  void swap(int i1, int j1, int i2, int j2) {
    setState(() {
      final temp = blocks[i1][j1];
      blocks[i1][j1] = blocks[i2][j2];
      blocks[i2][j2] = temp;
    });
  }

  void handleTap(int i, int j) {
    if (i > 0 && blocks[i][j] == blocks[i - 1][j]) {
      swap(i, j, i - 1, j);
      return;
    }
    if (i < rows - 1 && blocks[i][j] == blocks[i + 1][j]) {
      swap(i, j, i + 1, j);
      return;
    }
    if (j > 0 && blocks[i][j] == blocks[i][j - 1]) {
      swap(i, j, i, j - 1);
      return;
    }
    if (j < columns - 1 && blocks[i][j] == blocks[i][j + 1]) {
      swap(i, j, i, j + 1);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Colorful Block Game',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: rows * columns,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns),
          itemBuilder: (BuildContext context, int index) {
            final i = index ~/ columns;
            final j = index % columns;
            return GestureDetector(
              onTap: () => handleTap(i, j),
              child: Container(
                decoration: BoxDecoration(
                  color: blocks[i][j],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.all(4.0),
              ),
            );
          },
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () => generateBlocks(),
          child: Text('New Game'),
        ),
      ],
    );
  }
}

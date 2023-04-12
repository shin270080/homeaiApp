import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(ColorfulBlockGame());
}

class ColorfulBlockGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colorful Block Game',
      home: ColorfulBlockGameHomePage(),
    );
  }
}

class ColorfulBlockGameHomePage extends StatefulWidget {
  @override
  _ColorfulBlockGameHomePageState createState() =>
      _ColorfulBlockGameHomePageState();
}

class _ColorfulBlockGameHomePageState extends State<ColorfulBlockGameHomePage> {
  Random random = Random();
  List<Color> colors = [    Colors.red,    Colors.blue,    Colors.green,    Colors.yellow,    Colors.purple,    Colors.orange  ];

  Color currentColor = Colors.white;
  double position = 0.0;

  void changeColorAndPosition() {
    setState(() {
      currentColor = colors[random.nextInt(colors.length)];
      position = random.nextDouble() * 300;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Colorful Block Game'),
      ),
      body: GestureDetector(
        onTap: changeColorAndPosition,
        child: Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.only(left: position, top: position),
          decoration: BoxDecoration(
            color: currentColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(home: Rotate()));
}

class Rotate extends StatefulWidget {
  const Rotate({super.key});

  @override
  RotateState createState() => RotateState();
}

class RotateState extends State<Rotate> {
  double rotation = 0.0;
  double startRotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onScaleStart: (details) {
            startRotation = rotation;
          },
          onScaleUpdate: (details) {
            setState(() {
              rotation = startRotation + details.rotation;
            });
          },
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              width: 200,
              height: 200,
              color: Colors.orange,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}

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
  double _rotation = 0.0;
  double _scale = 1.0;
  double _startRotation = 0.0;
  double _startScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onScaleStart: (details) {
            _startRotation = _rotation;
            _startScale = _scale;
          },
          onScaleUpdate: (details) {
            setState(() {
              _rotation = _startRotation + details.rotation;
              _scale = _startScale * details.scale;
            });
          },
          child: Stack(
            children: [
              Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform:
                  Matrix4.identity()
                    ..scale(_scale)
                    ..rotateZ(_rotation),
                  child: Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(color: Colors.yellow),
                    child: Text("data"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

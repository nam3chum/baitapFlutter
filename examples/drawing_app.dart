import 'package:flutter/material.dart';

void main() => runApp(DrawingApp());

class DrawingApp extends StatelessWidget {
  const DrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: DrawingPage());
  }
}

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  DrawingPageState createState() => DrawingPageState();
}

class DrawingPageState extends State<DrawingPage> {
  List<Offset> strokes = [];
  Offset currentStroke = Offset(0, 0);
  bool isStopDrawing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            tooltip: 'Undo',
            onPressed: () {
              setState(() {
                if (strokes.isNotEmpty && isStopDrawing == false) {
                  strokes.removeLast();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Clear All',
            onPressed: () {
              setState(() {
                strokes.clear();
                isStopDrawing = false;
              });
            },
          ),
          TextButton(
            onPressed: () {
                isStopDrawing = true;
            },
            child: Text("finish"),
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            if (!isStopDrawing) {
              strokes.add(details.localPosition);
            }
          });
        },

        child: CustomPaint(size: Size.infinite, painter: DrawingPainter(strokes: strokes)),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> strokes;

  DrawingPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4.0;

    for (int i = 0; i < strokes.length - 1; i++) {
      canvas.drawLine(strokes[i], strokes[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

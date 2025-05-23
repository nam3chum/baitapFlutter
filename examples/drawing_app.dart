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
  List<List<Offset>> strokes = [];
  List<Offset> currentStroke = [];

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
                if (strokes.isNotEmpty) {
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
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            currentStroke = details.localPosition as List<Offset>;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            currentStroke.add(details.localPosition);
          });
        },
        onPanEnd: (details) {
          setState(() {
            if (currentStroke.length > 1) {
              strokes.add(List.from(currentStroke));
            }
            currentStroke = [];
          });
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: DrawingPainter(strokes: strokes, currentStroke: currentStroke),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;

  DrawingPainter({required this.strokes, required this.currentStroke});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4.0;

    for (var stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }

    // Vẽ nét đang vẽ (chưa được add vào strokes)
    for (int i = 0; i < currentStroke.length - 1; i++) {
      canvas.drawLine(currentStroke[i], currentStroke[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

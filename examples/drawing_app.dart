import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const DrawingApp());

class DrawingApp extends StatelessWidget {
  const DrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DrawingPage());
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
  Timer? undoTimer;
  int? selectedStrokeIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onLongPressStart: (_) {
              undoTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
                _handleUndo();
              });
            },
            onLongPressEnd: (_) {
              undoTimer?.cancel();
            },
            onTap: _handleUndo,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.undo, size: 28),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear All',
            onPressed: () {
              setState(() {
                strokes.clear();
                selectedStrokeIndex = null;
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTapDown: (details) {
          final tappedPoint = details.localPosition;
          const double tolerance = 10.0;

          setState(() {
            selectedStrokeIndex = null;
            for (int i = strokes.length - 1; i >= 0; i--) {
              for (final point in strokes[i]) {
                if ((point - tappedPoint).distance <= tolerance) {
                  selectedStrokeIndex = i;
                  return;
                }
              }
            }

          });
        },

        onPanStart: (details) {
          setState(() {
            selectedStrokeIndex = null;
            currentStroke = [details.localPosition, details.localPosition];
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
          painter: DrawingPainter(
            strokes: strokes,
            currentStroke: currentStroke,
            selectedIndex: selectedStrokeIndex,
          ),
        ),
      ),
    );
  }

  void _handleUndo() {
    setState(() {
      if (selectedStrokeIndex != null) {
        strokes.removeAt(selectedStrokeIndex!);
        selectedStrokeIndex = null;
      } else if (strokes.isNotEmpty) {
        strokes.removeLast();
      }
    });
  }
}

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final int? selectedIndex;

  DrawingPainter({
    required this.strokes,
    required this.currentStroke,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final redPaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < strokes.length; i++) {
      final paint = (i == selectedIndex) ? redPaint : blackPaint;
      final stroke = strokes[i];
      for (int j = 0; j < stroke.length - 1; j++) {
        canvas.drawLine(stroke[j], stroke[j + 1], paint);
      }
    }

    for (int i = 0; i < currentStroke.length - 1; i++) {
      canvas.drawLine(currentStroke[i], currentStroke[i + 1], blackPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

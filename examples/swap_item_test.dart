import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: VerticalCardSwapDemo()));
}

class VerticalCardSwapDemo extends StatefulWidget {
  const VerticalCardSwapDemo({super.key});

  @override
  State<VerticalCardSwapDemo> createState() => _VerticalCardSwapDemoState();
}

class _VerticalCardSwapDemoState extends State<VerticalCardSwapDemo> {
  final List<_CardData> cards = List.generate(
    6,
        (index) => _CardData(
      id: index,
      label: 'Thẻ ${index + 1}',
      position: Offset(100, 50.0 + index * 100),
    ),
  );

  int? draggingId;
  Offset dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: cards.map((card) {
          final isDragging = card.id == draggingId;

          Offset displayPos = isDragging ? dragOffset : card.position;

          return Positioned(
            left: displayPos.dx,
            top: displayPos.dy,
            child: GestureDetector(
              onPanStart: (_) {
                setState(() {
                  draggingId = card.id;
                  dragOffset = card.position;

                  final draggingCard = cards.firstWhere((c) => c.id == draggingId);
                  cards.remove(draggingCard);
                  cards.add(draggingCard);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  dragOffset += details.delta;
                });
              },
              onPanEnd: (_) {
                setState(() {
                  final draggedCard = cards.firstWhere((c) => c.id == draggingId);
                  draggedCard.position = dragOffset;
                  draggingId = null;
                });
              },
              child: Opacity(
                opacity: isDragging ? 0.9 : 1.0,
                child: _buildCard(card.label),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCard(String text) {
    return Container(
      width: 120,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      alignment: Alignment.center,
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}

class _CardData {
  final int id;
  final String label;
  Offset position;

  _CardData({required this.id, required this.label, required this.position});
}

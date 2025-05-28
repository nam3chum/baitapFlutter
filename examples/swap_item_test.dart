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
  final double cardWidth = 120;
  final double cardHeight = 80;
  final double spacing = 12;
  final double columnWidth = 140;
  final double baseLeft = 20;
  final double baseTop = 50;

  final List<List<_CardData>> columns = List.generate(3, (_) => []);

  final List<_CardData> allCards = List.generate(
    6,
        (i) => _CardData(id: i, label: 'Thẻ ${i + 1}'),
  );

  int? draggingId;
  Offset dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    columns[1].addAll(allCards);
    _updateCardPositions();
  }

  void _updateCardPositions() {
    for (int col = 0; col < 3; col++) {
      double x = baseLeft + col * columnWidth;
      for (int i = 0; i < columns[col].length; i++) {
        columns[col][i].position = Offset(x, baseTop + i * (cardHeight + spacing));
      }
    }
  }

  int _getClosestColumn(double xCenter) {
    final centers = List.generate(3, (i) => baseLeft + i * columnWidth + cardWidth / 2);
    double minDist = double.infinity;
    int closestCol = 0;
    for (int i = 0; i < centers.length; i++) {
      final dist = (xCenter - centers[i]).abs();
      if (dist < minDist) {
        minDist = dist;
        closestCol = i;
      }
    }
    return closestCol;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Màu nền từng cột
          Positioned.fill(
            child: Row(
              children: [
                Expanded(child: Container(color: Colors.red.withOpacity(0.1))),
                Expanded(child: Container(color: Colors.green.withOpacity(0.1))),
                Expanded(child: Container(color: Colors.blue.withOpacity(0.1))),
              ],
            ),
          ),

          // Hiển thị các thẻ
          ...columns.expand((col) => col).map((card) {
            final isDragging = draggingId == card.id;
            final pos = isDragging ? dragOffset : card.position;

            return Positioned(
              left: pos.dx,
              top: pos.dy,
              child: GestureDetector(
                onPanStart: (_) {
                  setState(() {
                    draggingId = card.id;
                    dragOffset = card.position;
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    dragOffset += details.delta;
                  });
                },
                onPanEnd: (_) {
                  final draggedCard = allCards.firstWhere((c) => c.id == draggingId);
                  final centerX = dragOffset.dx + cardWidth / 2;
                  final targetCol = _getClosestColumn(centerX);

                  setState(() {
                    for (final col in columns) {
                      col.remove(draggedCard);
                    }
                    columns[targetCol].add(draggedCard);
                    _updateCardPositions();
                    draggingId = null;
                  });
                },
                child: Opacity(
                  opacity: isDragging ? 0.85 : 1,
                  child: _buildCard(card.label),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCard(String label) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
      ),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}

class _CardData {
  final int id;
  final String label;
  Offset position;

  _CardData({required this.id, required this.label, this.position = Offset.zero});
}

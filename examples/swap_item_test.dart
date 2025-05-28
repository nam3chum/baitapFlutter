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
  final double baseTop = 50;

  final List<_CardData> cards = List.generate(
    6,
    (index) => _CardData(id: index, label: 'Thẻ ${index + 1}', position: Offset(0, 0)),
  );

  int? draggingId;
  Offset dragOffset = Offset.zero;

  final Map<int, List<_CardData>> columnCards = {0: [], 1: [], 2: []};

  @override
  void initState() {
    super.initState();
    columnCards[1]!.addAll(cards);
    _recalculatePositions();
  }

  void _recalculatePositions() {
    for (int col = 0; col < 3; col++) {
      final x = 20 + col * columnWidth;
      final list = columnCards[col]!;
      for (int i = 0; i < list.length; i++) {
        list[i].position = Offset(x, baseTop + i * (cardHeight + spacing));
      }
    }
  }

  int _getColumnFromX(double x) {
    if (x < 140) return 0;
    if (x < 280) return 1;
    return 2;
  }

  double _getColumnX(int column) => 20 + column * columnWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 3 vùng màu
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(child: Container(color: Colors.red.withOpacity(0.2))),
                    Expanded(child: Container(color: Colors.green.withOpacity(0.2))),
                    Expanded(child: Container(color: Colors.blue.withOpacity(0.2))),
                  ],
                ),
              ),

              // Các thẻ
              ...[...columnCards.values.expand((e) => e)].map((card) {
                final isDragging = card.id == draggingId;
                final displayPos = isDragging ? dragOffset : card.position;

                return Positioned(
                  left: displayPos.dx,
                  top: displayPos.dy,
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
                      setState(() {
                        final draggedCard = cards.firstWhere((c) => c.id == draggingId);
                        final targetCol = _getColumnFromX(dragOffset.dx);

                        for (var list in columnCards.values) {
                          list.remove(draggedCard);
                        }
                        columnCards[targetCol]!.add(draggedCard);
                        _recalculatePositions();

                        draggingId = null;
                      });
                    },
                    child: Opacity(opacity: isDragging ? 0.9 : 1.0, child: _buildCard(card.label)),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(String text) {
    return Container(
      width: cardWidth,
      height: cardHeight,
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

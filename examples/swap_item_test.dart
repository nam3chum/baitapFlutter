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
      position: Offset(100, 50.0 + index * 100), // Sắp xếp dọc
    ),
  );

  int? draggingId;
  int? hoverTargetId;
  Offset dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: cards.map((card) {
          final isDragging = draggingId == card.id;

          Offset displayPos = card.position;

          if (draggingId != null && hoverTargetId != null) {
            if (card.id == hoverTargetId) {
              displayPos = cards.firstWhere((c) => c.id == draggingId).position;
            } else if (card.id == draggingId) {
              displayPos = dragOffset;
            }
          } else if (isDragging) {
            displayPos = dragOffset;
          }

          return Positioned(
            left: displayPos.dx,
            top: displayPos.dy,
            child: GestureDetector(
              onPanStart: (_) {
                setState(() {
                  draggingId = card.id;
                  dragOffset = card.position;
                  hoverTargetId = null;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  dragOffset += details.delta;

                  final draggedRect = Rect.fromLTWH(dragOffset.dx, dragOffset.dy, 120, 80);

                  _CardData? closestCard;
                  double minDistance = double.infinity;

                  for (var other in cards) {
                    if (other.id == card.id) continue;

                    final otherRect = Rect.fromLTWH(
                      other.position.dx, other.position.dy, 120, 80,
                    );

                    if (draggedRect.overlaps(otherRect)) {
                      final dist = (dragOffset + const Offset(60, 40) -
                          (other.position + const Offset(60, 40)))
                          .distance;
                      if (dist < minDistance) {
                        minDistance = dist;
                        closestCard = other;
                      }
                    }
                  }

                  hoverTargetId = closestCard?.id;
                });
              },
              onPanEnd: (_) {
                setState(() {
                  final draggedCard = cards.firstWhere((c) => c.id == draggingId);

                  if (draggingId != null && hoverTargetId != null) {
                    final targetCard = cards.firstWhere((c) => c.id == hoverTargetId);

                    final temp = targetCard.position;
                    targetCard.position = draggedCard.position;
                    draggedCard.position = temp;
                  } else {
                    draggedCard.position = dragOffset;
                  }

                  draggingId = null;
                  hoverTargetId = null;
                });
              },
              child: Opacity(
                opacity: isDragging ? 0.85 : 1.0,
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
        color: Colors.teal[700],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

class _CardData {
  final int id;
  final String label;
  Offset position;

  _CardData({required this.id, required this.label, required this.position});
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: FreeDraggableCards()));
}

class FreeDraggableCards extends StatefulWidget {
  const FreeDraggableCards({super.key});

  @override
  State<FreeDraggableCards> createState() => _FreeDraggableCardsState();
}

class _FreeDraggableCardsState extends State<FreeDraggableCards> {
  final List<_CardData> cards = List.generate(
    5,
        (index) => _CardData(
      id: index,
      label: 'Thẻ ${index + 1}',
      position: Offset(50.0 + index * 100, 100.0),
    ),
  );

  int? draggingId;
  int? lastSwappedId;
  Offset dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kéo & hoán đổi thẻ tự do")),
      body: Stack(
        children: cards.map((card) {
          final isDragging = draggingId == card.id;
          return Positioned(
            left: isDragging ? dragOffset.dx : card.position.dx,
            top: isDragging ? dragOffset.dy : card.position.dy,
            child: GestureDetector(
              onPanStart: (_) {
                setState(() {
                  draggingId = card.id;
                  dragOffset = card.position;
                  lastSwappedId = null;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  dragOffset += details.delta;

                  final draggedRect = Rect.fromLTWH(
                    dragOffset.dx, dragOffset.dy, 100, 60,
                  );

                  _CardData? closestCard;
                  double minDistance = double.infinity;

                  for (var other in cards) {
                    if (other.id == card.id || other.id == lastSwappedId) continue;

                    final otherRect = Rect.fromLTWH(
                      other.position.dx, other.position.dy, 100, 60,
                    );

                    if (draggedRect.overlaps(otherRect)) {
                      final dist = (dragOffset + const Offset(50, 30) -
                          (other.position + const Offset(50, 30)))
                          .distance;
                      if (dist < minDistance) {
                        minDistance = dist;
                        closestCard = other;
                      }
                    }
                  }

                  if (closestCard != null) {
                    final currentCard = cards.firstWhere((c) => c.id == card.id);
                    final targetCard = cards.firstWhere((c) => c.id == closestCard?.id);
                    final temp = currentCard.position;
                    currentCard.position = targetCard.position;
                    targetCard.position = temp;
                    lastSwappedId = closestCard.id;
                  }
                });
              },
              onPanEnd: (_) {
                setState(() {
                  final currentCard = cards.firstWhere((c) => c.id == card.id);
                  currentCard.position = dragOffset;
                  draggingId = null;
                  lastSwappedId = null;
                });
              },
              child: Opacity(
                opacity: isDragging ? 0.7 : 1.0,
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
      width: 100,
      height: 60,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18),
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

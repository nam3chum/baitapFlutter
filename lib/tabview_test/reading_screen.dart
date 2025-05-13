import 'package:flutter/material.dart';
import 'package:navigation_test/tabview_test/reading_state/reading_stats_model.dart';

import 'Model/story.dart';

class ReadingPage extends StatefulWidget {
  final Story story;

  const ReadingPage({super.key, required this.story});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    final duration = DateTime.now().difference(_startTime);
    _updateReadingStats(duration);
    super.dispose();
  }

  void _updateReadingStats(Duration duration) {
    ReadingStatsManager().updateReading(
      widget.story.id,
      widget.story.title,
      widget.story.author,
      duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: Icon(Icons.arrow_back_sharp),
        ),
      ),
      body: const Center(child: Text("Đang đọc truyện")),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:navigation_test/tabview_test/reading_state/reading_stats_model.dart';

import '../Model/readingstate.dart';

class ReadingStatsScreen extends StatefulWidget {
  const ReadingStatsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReadingStatsScreenState();
  }
}

class ReadingStatsScreenState extends State<ReadingStatsScreen> {
  List<ReadingStats> stats = [];
  Duration? maxReadTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    stats = ReadingStatsManager().stats;
  }

  ReadingStats? getTopStory() {
    if (stats.isEmpty) return null;
    return stats.reduce((a, b) => a.totalReadingTime >= b.totalReadingTime ? a : b);
  }

  void refreshStats() {
    setState(() {
      _loadStats();
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${hours}h ${minutes}m ${seconds}s';
  }

  String _formatDateTime(DateTime? date) {
    return '${date?.year}-${date?.month}-${date?.day} ${date?.hour}:${date?.minute}:${date?.second}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thống kê thời gian đọc truyện')),
      body:
          stats.isEmpty
              ? const Center(child: Text("Chưa có dữ liệu đọc truyện"))
              : Stack(
                children: [
                  ListView.builder(
                    itemCount: stats.length,
                    itemBuilder: (context, index) {
                      final stat = stats[index];
                      return ListTile(
                        leading: const Icon(Icons.book),
                        title: Text(stat.storyTitle),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tác giả: ${stat.author}"),
                            Text("Tổng thời gian đọc: ${_formatDuration(stat.totalReadingTime)}"),
                            if (stat.lastRead != null)
                              Text("Lần đọc gần nhất: ${_formatDateTime(stat.lastRead)}"),
                            if (stat.totalReadingTime == getTopStory()?.totalReadingTime)
                              Text("đây là nhiều nhất: ${stat.storyTitle}"),
                          ],
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue,
                        ),
                        child: Text(
                          "Truyện được đọc nhiều nhất: ${getTopStory()?.storyTitle}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}

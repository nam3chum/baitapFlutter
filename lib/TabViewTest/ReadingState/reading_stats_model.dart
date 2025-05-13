import '../Model/readingstate.dart';

class ReadingStatsManager {
  static final ReadingStatsManager _instance = ReadingStatsManager._internal();

  factory ReadingStatsManager() {
    return _instance;
  }

  ReadingStatsManager._internal();

  final List<ReadingStats> stats = [];

  List<ReadingStats> get stat => stats;

  void updateReading(int storyId, String title, String author, Duration duration) {
    final existing = stats.firstWhere(
      (e) => e.storyId == storyId,
      orElse: () {
        final newStat = ReadingStats(storyId: storyId, storyTitle: title, author: author);
        stats.add(newStat);
        return newStat;
      },
    );

    existing.totalReadingTime += duration;
    existing.lastRead = DateTime.now();
    stats.sort(
          (a, b) => b.totalReadingTime.compareTo(a.totalReadingTime),
    );
  }
}

class ReadingStats {
  final int storyId;
  final String storyTitle;
  final String author;
  Duration totalReadingTime;
  DateTime? lastRead;

  ReadingStats({
    required this.storyId,
    required this.storyTitle,
    required this.author,
    this.totalReadingTime = Duration.zero,
    this.lastRead,
  });
}

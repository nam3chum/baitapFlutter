import 'package:flutter/material.dart';

import '../Model/readingstate.dart';

class ReadingStatsPage extends StatelessWidget {
  // Tạo danh sách truyện đã đọc
  final List<ReadingStats> readingStatsList = [
    ReadingStats(
      title: "Cổ Chân Nhân",
      author: "Cổ Chân Nhân",
      timeSpent: "10 phút",
      dateRead: DateTime.now(),
    ),
    ReadingStats(
      title: "Kiếm Lai",
      author: "Phòng Hoả Hí chư hầu",
      timeSpent: "5 phút",
      dateRead: DateTime.now(),
    ),
    ReadingStats(
      title: "Già Thiên",
      author: "Thần Đông",
      timeSpent: "2 phút",
      dateRead: DateTime.now(),
    ),
  ];

   ReadingStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thống kê truyện đã đọc'),
      ),
      body: ListView.builder(
        itemCount: readingStatsList.length,
        itemBuilder: (context, index) {
          ReadingStats stats = readingStatsList[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(stats.title),
              subtitle: Text('${stats.author} - Đọc trong ${stats.timeSpent}'),
              trailing: Text('${stats.dateRead.toLocal()}'),
            ),
          );
        },
      ),
    );
  }
}

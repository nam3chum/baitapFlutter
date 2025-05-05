
import 'package:flutter/material.dart';
import 'package:prjtest/TabViewTest/HistoryList/read_history_model.dart';

import '../Model/story.dart';
import '../story_detail.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = ReadHistoryModel().stories;

    return Scaffold(
      appBar: AppBar(title: Text("Lịch sử đọc"),),
      body:
      stories.isEmpty
          ? Center(child: Text('Chưa có truyện nào trong kệ'))
          : ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return _buildStoryItem(story, context);
        },
      ),
    );
  }
}

Widget _buildStoryItem(Story story, BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StoryDetailPage(story: story)),
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(story.urlImg, width: 40, height: 80, fit: BoxFit.cover),
          ),
          // Nội dung truyện
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Tác giả: ${story.author}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),

                  Text('${story.numOfChapter} chương', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
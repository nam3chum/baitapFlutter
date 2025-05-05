import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prjtest/TabViewTest/StoryList/story_list_screen.dart';

import '../Model/genre.dart';
import '../Model/story.dart';
import '../story_detail.dart';

class GenreStoryListScreen extends StatelessWidget {
  final Genre genre;

  const GenreStoryListScreen({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    final List<Story> filteredStories = stories
        .where((story) => story.genres.any((g) => g.name == genre.name))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("Thể loại: ${genre.name}")),
      body: ListView.builder(
        itemCount: filteredStories.length,
        itemBuilder: (context, index) {
          final story = filteredStories[index];
          return _buildStoryItem(story, context); // dùng lại item bạn đã tạo
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
        context.push('/story',extra: story);
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(story.urlImg, width: 120, height: 180, fit: BoxFit.cover),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tác giả: ${story.author}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.menu_book, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('${story.numOfChapter} chương', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Wrap(
                      spacing: 8,
                      children:
                      story.genres
                          .map(
                            (type) =>
                            Chip(label: Text(type.name, style: TextStyle(fontSize: 10))),
                      )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prjtest/TabViewTest/Bookshelf/bookshelf_model.dart';
import 'package:prjtest/TabViewTest/HistoryList/read_history_model.dart';
import 'package:prjtest/TabViewTest/Model/story.dart';

import 'StoryList/genre_list_screen.dart';

class StoryDetailPage extends StatefulWidget {
  final Story story;

  const StoryDetailPage({super.key, required this.story});

  @override
  State<StatefulWidget> createState() {
    return StoryDetailPageState();
  }
}

class StoryDetailPageState extends State<StoryDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  void addToBookshelf() {
    BookshelfModel().add(widget.story);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã thêm vào kệ sách')));
  }

  void addToHistory() {
    ReadHistoryModel().add(widget.story);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black.withValues(alpha: 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBottomItem(Icons.menu_book, "mục lục", () {}),
            _buildBottomItem(Icons.play_circle, "đọc truyện", addToHistory),
            _buildBottomItem(Icons.add, "Thêm vào kệ", addToBookshelf),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Hình nền và các phần nội dung khác
          Positioned.fill(
            child: Image.asset(widget.story.urlImg, fit: BoxFit.cover),
          ),
          Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.6))),
          // Nội dung chính cuộn được
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.bookmark_border, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Hình ảnh truyện và thông tin
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Story image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          widget.story.urlImg,
                          width: 100,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Thông tin truyện
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.story.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.story.author,
                              style: const TextStyle(fontSize: 16, color: Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.story.numOfChapter.toString(),
                              style: const TextStyle(fontSize: 16, color: Colors.orangeAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Thể loại
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 8,
                    children:
                        widget.story.genres
                            .map(
                              (type) => ActionChip(
                                label: Text(type.name),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => GenreStoryListScreen(genre: type),
                                    ),
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                // Mô tả truyện
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Giới thiệu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomItem(IconData iconItem, String labelText, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(icon: Icon(iconItem, color: Colors.white), onPressed: onTap),
        Text(labelText, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../Model/story.dart';
import '../genre_repository.dart';
import '../push_smart.dart';

final List<Story> stories = [
  Story(
    id: 0,
    title: 'Già Thiên',
    urlImg: 'assets/ImageStory/giathien.png',
    numOfChapter: 1896,
    author: "Thần Đông",
    genres: [GenreRepository.doThi, GenreRepository.tienHiep],
  ),
  Story(
    id: 1,
    title: 'Kiếm lai',
    urlImg: 'assets/ImageStory/kiemlai.png',
    numOfChapter: 700,
    author: "Phòng Hoả Hí chư hầu",
    genres: [
      GenreRepository.huyenHuyen,
      GenreRepository.kiemHiep,
      GenreRepository.tienHiep,
      GenreRepository.xuyenKhong,
    ],
  ),
  Story(
    id: 2,
    title: 'Tiên công khai vật ',
    urlImg: 'assets/ImageStory/tiencongkhaivat.png',
    numOfChapter: 800,
    author: "Cổ chân nhân",
    genres: [GenreRepository.doThi, GenreRepository.tienHiep, GenreRepository.huyenHuyen],
  ),
  Story(
    id: 3,
    title: 'Cổ chân nhân',
    urlImg: 'assets/ImageStory/cochannhan.png',
    numOfChapter: 1000,
    author: "Cổ chân nhân",
    genres: [GenreRepository.xuyenKhong, GenreRepository.huyenHuyen, GenreRepository.tienHiep],
  ),
  Story(
    id: 4,
    title: 'Tiên Nghịch',
    urlImg: 'assets/ImageStory/tiennghich.png',
    numOfChapter: 1964,
    author: "Nhĩ Căn",
    genres: [GenreRepository.tienHiep, GenreRepository.huyenHuyen],
  ),
  Story(
    id: 5,
    title: 'Nhất niệm Vĩnh hằng',
    urlImg: 'assets/ImageStory/nhatniemvinhhang.png',
    numOfChapter: 1545,
    author: "Nhĩ Căn",
    genres: [GenreRepository.tienHiep, GenreRepository.huyenHuyen],
  ),
  Story(
    id: 6,
    title: 'Linh Vực    ',
    urlImg: 'assets/ImageStory/linhvuc.png',
    numOfChapter: 1935,
    author: "Nghịch Thương Thiên",
    genres: [GenreRepository.doThi, GenreRepository.huyenHuyen],
  ),
  Story(
    id: 7,
    title: 'Kiếm lai',
    urlImg: 'assets/ImageStory/kiemlai.png',
    numOfChapter: 700,
    author: "Phòng Hoả Hí chư hầu",
    genres: [GenreRepository.xuyenKhong, GenreRepository.huyenHuyen, GenreRepository.tienHiep],
  ),
  Story(
    id: 8,
    title: 'Tiên công khai vật ',
    urlImg: 'assets/ImageStory/tiencongkhaivat.png',
    numOfChapter: 800,
    author: "Cổ chân nhân",
    genres: [GenreRepository.doThi, GenreRepository.tienHiep, GenreRepository.huyenHuyen],
  ),
  Story(
    id: 9,
    title: 'Kiếm lai',
    urlImg: 'assets/ImageStory/kiemlai.png',
    numOfChapter: 700,
    author: "Phòng Hoả Hí chư hầu",
    genres: [GenreRepository.doThi, GenreRepository.huyenHuyen],
  ),
  Story(
    id: 10,
    title: 'Tiên công khai vật ',
    urlImg: 'assets/ImageStory/tiencongkhaivat.png',
    numOfChapter: 800,
    author: "Cổ chân nhân",
    genres: [GenreRepository.doThi, GenreRepository.huyenHuyen],
  ),
];

class StoryListScreen extends StatefulWidget {
  const StoryListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StoryListScreenState();
  }
}

class StoryListScreenState extends State<StoryListScreen> {
  final controller = ScrollController();
  bool isShowButton = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(onListener);

  }

  void _scrollToTop() {
    controller.animateTo(0, duration: Duration(seconds: 1), curve: Curves.easeInOut).then((_) {
      setState(() {
        isShowButton = false;
      });
    });
  }

  void onListener() {
    if (controller.offset > 500 && !isShowButton) {
      setState(() {
        isShowButton = true;
      });
    } else if (controller.offset <= 500 && isShowButton) {
      setState(() => isShowButton = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            key: widget.key,
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return _buildStoryItem(story, context);
            },
          ),
          if (isShowButton)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: InkWell(
                  onTapDown: (_) => _scrollToTop(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Icon(Icons.upgrade_outlined),
                  ),
                ),
              ),
            ),
        ],
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
        pushSmart(context, '/detail',story);
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

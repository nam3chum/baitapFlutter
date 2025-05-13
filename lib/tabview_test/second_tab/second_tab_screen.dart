import 'package:flutter/material.dart';

import '../bookself/bookshelf_model.dart';
import '../bookself/bookshelf_screen.dart';
import '../history_list/history_list_screen.dart';
import '../reading_state/reading_state_screen.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return PersonalPageState();
  }
}

class PersonalPageState extends State<PersonalPage> {
  var _selectedIndex = 0;
  bool isShowAppBar = true;
  final ScrollController scrollController = ScrollController();

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
    //Navigator.popAndPushNamed(context, "/listStory");
  }

  void _pickRandomStory() {
    final stories = BookshelfModel().stories;

    if (stories.isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Không có sách trong kệ sách"),
              content: Text("Hãy thêm sách vào kệ để random sách trong kệ"),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
            ),
      );
      return;
    }

    final randomStory = (stories..shuffle()).first;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Random truyện trong kệ sách"),
            content: RichText(
              text: TextSpan(
                text: "Bạn nên đọc thử:\n",
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: randomStory.title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(text: "\nTác giả: "),
                  TextSpan(text: randomStory.author, style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    switch (_selectedIndex) {
      case 0:
        currentScreen = ReadingStatsScreen();
        break;
      case 1:
        currentScreen = BookshelfScreen();
        break;
      case 2:
        currentScreen = HistoryScreen();
        break;
      default:
        currentScreen = Container();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Trang Cá Nhân')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              curve: Curves.bounceOut,
              child: Text(
                'Xin chào\nPhương Nam',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Thống kê'),
              onTap: () {
                setState(() {
                  _onItemTap(0);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Kệ Sách'),
              onTap: () {
                setState(() {
                  _onItemTap(1);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Lịch sử dọc'),
              onTap: () {
                setState(() {
                  _onItemTap(2);
                });
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onDoubleTap: () {
          setState(() {
            isShowAppBar = !isShowAppBar;
          });
        },
        child: currentScreen,
      ),
      bottomNavigationBar:
          isShowAppBar == false
              ? null
              : BottomAppBar(
                shape: CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.star), // Mục tiêu đọc
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.recommend), // Đề xuất truyện đọc
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications), // Thông báo
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.share), // Chia sẻ truyện
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
      floatingActionButton:
          isShowAppBar == false
              ? null
              : FloatingActionButton(
                onPressed: _pickRandomStory,
                tooltip: 'Thêm danh sách truyện yêu thích',
                child: Icon(Icons.casino),
              ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

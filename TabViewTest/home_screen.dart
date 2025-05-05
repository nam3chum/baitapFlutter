import 'package:flutter/material.dart';
import 'package:prjtest/TabViewTest/StoryList/story_list_screen.dart';
import 'package:prjtest/TabViewTest/router.dart';

import 'Bookshelf/bookshelf_screen.dart';
import 'HistoryList/history_list_screen.dart';
import 'SecondTab/second_tab_screen.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await ReadHistoryModel().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Bottom Nav with Tabs & Drawer',
      theme: ThemeData(primaryColorDark: Colors.black),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [FirstTabScreen(), PersonalPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
    );
  }
}

class FirstTabScreen extends StatelessWidget {
  const FirstTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [Tab(text: 'list truyện'), Tab(text: 'kệ sách'), Tab(text: 'lịch sử đọc')],
          ),
        ),
        body: TabBarView(
          //controller: controller,
          children: [StoryListScreen(), BookshelfScreen(), HistoryScreen()],
        ),
      ),
    );
  }
}

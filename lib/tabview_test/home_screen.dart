import 'package:flutter/material.dart';

import 'package:navigation_test/tabview_test/second_tab/second_tab_screen.dart';
import 'package:navigation_test/tabview_test/story_detail.dart';

import 'Model/genre.dart';
import 'Model/story.dart';
import 'StoryList/genre_list_screen.dart';
import 'StoryList/story_list_screen.dart';
import 'bookself/bookshelf_screen.dart';
import 'history_list/history_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await ReadHistoryModel().init();
  runApp(MyApp());
}

MaterialPageRoute? routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => MainScreen());
    case '/listStory':
      return MaterialPageRoute(builder: (_) => StoryListScreen());
    case '/detail':
      final arg = settings.arguments as Story;
      return MaterialPageRoute(builder: (_) => StoryDetailPage(story: arg));
    case '/genres':
      final arg = settings.arguments as Genre;
      return MaterialPageRoute(builder: (_) => GenreStoryListScreen(genre: arg));
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(body: Center(child: Text("4040 not foud!!!!"))),
      );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: routes,
      title: 'Demo App',
      theme: ThemeData(primaryColorDark: Colors.black),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [FirstTabScreen(), PersonalPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),

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

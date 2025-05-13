import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation_test/TabViewTest/router.dart';

import 'Bookshelf/bookshelf_screen.dart';
import 'HistoryList/history_list_screen.dart';
import 'StoryList/story_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await ReadHistoryModel().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Demo App',
      theme: ThemeData(primaryColorDark: Colors.black),
    );
  }
}


class MainScreen extends StatelessWidget{
 final Widget child;
   const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int index = 0;
    if (location.startsWith('/profile')) index = 1;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/profile');
              break;
          }
        },
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

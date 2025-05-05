import 'package:flutter/material.dart';
import 'package:prjtest/TabViewTest/Bookshelf/bookshelf_screen.dart';

import '../HistoryList/history_list_screen.dart';
import '../ReadingState/reading_state_screen.dart';

class PersonalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PersonalPageState();
  }
}

class PersonalPageState extends State<PersonalPage> {
  var _selectedIndex = 0;
  final List<Widget> _screen = [ReadingStatsPage(), BookshelfScreen(), HistoryScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật index khi nhấn vào ListTile trong Drawer
    });
    Navigator.pop(context); // Đóng Drawer sau khi chọn mục
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trang Cá Nhân')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
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
                  _onItemTapped(0);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Kệ Sách'),
              onTap: () {
                setState(() {
                  _onItemTapped(1);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Lịch sử dọc'),
              onTap: () {
                setState(() {
                  _onItemTapped(2);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Đăng Xuất'),
              onTap: () {
                // Xử lý đăng xuất
              },
            ),
          ],
        ),
      ),
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.star), // Mục tiêu đọc
              onPressed: () {
                // Xử lý mục tiêu đọc
              },
            ),
            IconButton(
              icon: Icon(Icons.recommend), // Truyện đề xuất
              onPressed: () {
                // Xử lý truyện đề xuất
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications), // Thông báo
              onPressed: () {
                // Xử lý thông báo
              },
            ),
            IconButton(
              icon: Icon(Icons.share), // Chia sẻ truyện
              onPressed: () {
                // Xử lý chia sẻ truyện
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        tooltip: 'Tạo danh sách truyện mới',
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // Đặt FAB giữa BottomAppBar
    );
  }
}

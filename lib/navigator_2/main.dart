import 'package:flutter/material.dart';
import 'package:navigation_test/navigator_2/route_delegate.dart';
import 'package:navigation_test/navigator_2/route_information_parser.dart';

import 'appstate.dart';

void main() {
  runApp(MyApp());
}

// Ứng dụng chính
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // Khởi tạo trạng thái là trang Home
  AppState appState = AppState(page: PageType.home);
  // Cập nhật trạng thái và buộc cập nhật UI
  void _setNewRoutePath(AppState state) {
    setState(() {
      appState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'navigator 2.0 Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: MyRouteInformationParser(),
      routerDelegate: MyRouterDelegate(appState: appState, onNewRoutePath: _setNewRoutePath),
    );
  }
}

// Trang chủ hiển thị danh sách các mục
class HomePage extends StatelessWidget {
  final Function(String) onItemTapped;
  final VoidCallback onSettingsTapped;

  const HomePage({super.key, required this.onItemTapped, required this.onSettingsTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: onSettingsTapped)],
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Mục ${index + 1}'),
            onTap: () => onItemTapped('item-${index + 1}'),
          );
        },
      ),
    );
  }
}

// Trang chi tiết hiển thị thông tin của một mục
class DetailsPage extends StatelessWidget {
  final String itemId;
  final VoidCallback onBackPressed;

  const DetailsPage({super.key, required this.itemId, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết'),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: onBackPressed),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chi tiết cho: $itemId', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: onBackPressed, child: Text('Quay lại trang chủ')),
          ],
        ),
      ),
    );
  }
}

// Trang cài đặt
class SettingsPage extends StatelessWidget {
  final VoidCallback onBackPressed;

  const SettingsPage({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: onBackPressed),
      ),
      body: ListView(
        children: [
          ListTile(leading: Icon(Icons.person), title: Text('Thông tin tài khoản')),
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Chế độ tối'),
            trailing: Switch(value: false, onChanged: (value) {}),
          ),
          ListTile(leading: Icon(Icons.notifications), title: Text('Thông báo')),
          ListTile(leading: Icon(Icons.language), title: Text('Ngôn ngữ')),
          ListTile(leading: Icon(Icons.info), title: Text('Về ứng dụng')),
        ],
      ),
    );
  }
}

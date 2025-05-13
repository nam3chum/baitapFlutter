import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Trang chủ"),
          NavigationDestination(icon: Icon(Icons.search), label: "Tìm kiếm"),
          NavigationDestination(icon: Icon(Icons.notifications), label: " Thông báo") ,NavigationDestination(icon: Icon(Icons.search), label: "Tìm kiếm"),
          NavigationDestination(icon: Icon(Icons.notifications), label: " Thông báo") ,NavigationDestination(icon: Icon(Icons.search), label: "Tìm kiếm"),
          NavigationDestination(icon: Icon(Icons.notifications), label: " Thông báo") ,NavigationDestination(icon: Icon(Icons.search), label: "Tìm kiếm"),
          NavigationDestination(icon: Icon(Icons.notifications), label: " Thông báo"),
        ],
        overlayColor: WidgetStatePropertyAll(Colors.blue),
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Navigation Stack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomNavigator(),
    );
  }
}

// Lớp quản lý điều hướng tùy chỉnh
class CustomNavigator extends StatefulWidget {
  @override
  _CustomNavigatorState createState() => _CustomNavigatorState();
}

class _CustomNavigatorState extends State<CustomNavigator> {
  // Khai báo một key cho Navigator để có thể điều khiển nó
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // Danh sách lưu trữ thông tin về các trang trong stack
  final List<PageInfo> _pageStack = [];

  @override
  void initState() {
    super.initState();
    // Thêm trang đầu tiên vào stack
    _pageStack.add(PageInfo(name: 'HomePage', identifier: 'home'));
  }

  // Hàm để thêm một trang mới vào stack
  void _pushPage(String name, String identifier) {
    // Kiểm tra xem có 4 trang cùng loại liên tiếp không
    int samePageCount = 0;
    for (int i = _pageStack.length - 1; i >= 0; i--) {
      if (_pageStack[i].identifier == identifier) {
        samePageCount++;
      } else {
        break;
      }
    }

    // Nếu đã có 4 trang cùng loại, xóa 3 trang cũ
    if (samePageCount >= 4) {
      // Lấy vị trí của trang đầu tiên trong chuỗi trang giống nhau
      int firstSamePageIndex = _pageStack.length - samePageCount;

      // Xóa các trang giữa, chỉ giữ lại trang đầu tiên và trang mới nhất
      _pageStack.removeRange(firstSamePageIndex + 1, _pageStack.length);
    }

    // Thêm trang mới vào stack
    setState(() {
      _pageStack.add(PageInfo(name: name, identifier: identifier));
    });

    // Điều hướng đến trang mới
    _navigateToPage(name, identifier);
  }

  // Điều hướng đến một trang
  void _navigateToPage(String name, String identifier) {
    _navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => _buildPage(name, identifier),
        )
    );
  }

  // Hàm xây dựng trang dựa trên identifier
  Widget _buildPage(String name, String identifier) {
    switch (identifier) {
      case 'home':
        return _buildGenericPage(name, identifier, Colors.blue);
      case 'detail':
        return _buildGenericPage(name, identifier, Colors.green);
      case 'profile':
        return _buildGenericPage(name, identifier, Colors.orange);
      default:
        return _buildGenericPage(name, identifier, Colors.grey);
    }
  }

  // Tạo một trang chung với nút để di chuyển đến các trang khác
  Widget _buildGenericPage(String name, String identifier, Color color) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đây là trang $name',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Stack hiện tại (${_pageStack.length} trang):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: _pageStack.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${index + 1}. ${_pageStack[index].name}'),
                    subtitle: Text('ID: ${_pageStack[index].identifier}'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () => _pushPage('Detail Page ${_pageStack.length + 1}', 'detail'),
              child: Text('Đi đến trang Detail'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              onPressed: () => _pushPage('Profile Page ${_pageStack.length + 1}', 'profile'),
              child: Text('Đi đến trang Profile'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Xử lý khi người dùng nhấn nút back
      onWillPop: () async {
        if (_pageStack.length <= 1) {
          // Nếu chỉ còn trang đầu tiên, cho phép thoát ứng dụng
          return true;
        } else {
          // Xử lý back khi có nhiều trang
          String currentIdentifier = _pageStack.last.identifier;

          // Kiểm tra số lượng trang cùng loại liên tiếp tính từ trang hiện tại
          int samePageCount = 0;
          for (int i = _pageStack.length - 1; i >= 0; i--) {
            if (_pageStack[i].identifier == currentIdentifier) {
              samePageCount++;
            } else {
              break;
            }
          }

          // Nếu có từ 4 trang cùng loại trở lên và đang ở trang thứ 4 (tính từ dưới lên)
          if (samePageCount >= 4 && _pageStack.length >= 4) {
            // Tìm trang đầu tiên trong chuỗi các trang cùng loại
            int firstSamePageIndex = _pageStack.length - samePageCount;

            // Xóa tất cả các trang giữa, chỉ giữ lại trang đầu tiên
            int currentLength = _pageStack.length;
            for (int i = 0; i < currentLength - firstSamePageIndex - 1; i++) {
              // Pop trang khỏi Navigator
              _navigatorKey.currentState!.pop();
              // Xóa trang khỏi stack
              _pageStack.removeLast();
            }
            return false;
          } else {
            // Xử lý back bình thường cho trường hợp không đủ 4 trang cùng loại
            _pageStack.removeLast();
            return true; // Cho phép Navigator tự xử lý pop
          }
        }
      },
      child: Navigator(
        key: _navigatorKey,
        // Trang ban đầu
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => _buildPage('HomePage', 'home'),
          );
        },
      ),
    );
  }
}

// Lớp lưu trữ thông tin về trang
class PageInfo {
  final String name;      // Tên hiển thị của trang
  final String identifier; // Định danh loại trang

  PageInfo({required this.name, required this.identifier});
}
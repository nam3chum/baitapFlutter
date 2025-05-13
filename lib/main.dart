import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: MyApp()));
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('hello cc lâu vl'));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  ChapterContentPageState createState() => ChapterContentPageState();
}

class ChapterContentPageState extends State<MyApp> {
  String _chapterContent = '';
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) async {
                final content = await _controller.runJavaScriptReturningResult("""
              (function() {
                var el = document.querySelector('#chapter_001');
                return el ? el.innerText : 'Không tìm thấy nội dung';
              })();
              """);

                setState(() {
                  _chapterContent = content.toString().replaceAll(r'\n', '\n').replaceAll('"', '');
                });
              },
            ),
          )
          ..loadRequest(Uri.parse('https://vozer.vn/kiem-lai/chuong-45'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nội dung chương 455')),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(16.0), child: Text(_chapterContent)),
      ),
    );
  }
}

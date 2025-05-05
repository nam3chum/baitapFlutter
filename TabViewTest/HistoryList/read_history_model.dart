import 'package:prjtest/TabViewTest/Model/story.dart';

class ReadHistoryModel {
  static final ReadHistoryModel _instance = ReadHistoryModel._internal();

  factory ReadHistoryModel() => _instance;

  ReadHistoryModel._internal();

  final List<Story> _history = [];
  final int _maxHistory = 50;

  List<Story> get stories => _history;

  void add(Story story) {
    _history.removeWhere((s) => s.title == story.title);
    _history.insert(0, story);
    if (_history.length > _maxHistory) {
      _history.removeRange(_maxHistory, _history.length);
    }
  }
  void clear() => _history.clear();
}

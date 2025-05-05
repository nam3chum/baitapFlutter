import 'package:flutter/material.dart';
import 'package:prjtest/TabViewTest/Model/story.dart';

class BookshelfModel {
  static final BookshelfModel _instance = BookshelfModel._internal();

  factory BookshelfModel() => _instance;

  BookshelfModel._internal();

  final List<Story> _bookshelf = [];

  List<Story> get stories => _bookshelf;

  void add(Story story) {
    if (!_bookshelf.any((s) => s.title == story.title)) {
      _bookshelf.add(story);
    }
  }

  void remove(Story story) {
    _bookshelf.removeWhere((s) => s.title == story.title);
  }

  bool contains(Story story) {
    return _bookshelf.any((s) => s.title == story.title);
  }

  void clear() => _bookshelf.clear();
}

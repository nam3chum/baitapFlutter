import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation_test/TabViewTest/story_detail.dart';

import 'Model/genre.dart';
import 'Model/story.dart';
import 'SecondTab/second_tab_screen.dart';
import 'StoryList/genre_list_screen.dart';
import 'StoryList/story_list_screen.dart';
import 'home_screen.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => FirstTabScreen()),
        GoRoute(path: '/profile', builder: (context, state) => PersonalPage()),
      ],
    ),
    GoRoute(
      path: '/listStory',
      builder: (context, state) {
        return StoryListScreen();
      },
    ),
    GoRoute(
      path: '/story',
      builder: (context, state) {
        final story = state.extra as Story;
        return StoryDetailPage(story: story);
      },
    ),
    GoRoute(
      path: '/genre',
      builder: (context, state) {
        final genre = state.extra as Genre;
        return GenreStoryListScreen(genre: genre);
      },
    ),
  ],
);

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prjtest/TabViewTest/home_screen.dart';
import 'package:prjtest/TabViewTest/story_detail.dart';

import 'Model/genre.dart';
import 'Model/story.dart';
import 'StoryList/genre_list_screen.dart';


final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MainScreen(),
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

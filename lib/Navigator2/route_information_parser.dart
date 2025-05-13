// Parser để chuyển đổi giữa URL và trạng thái ứng dụng
import 'package:flutter/material.dart';

import 'appstate.dart';

class MyRouteInformationParser extends RouteInformationParser<AppState> {
  @override
  Future<AppState> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.uri.toString());

    // Xử lý trang chủ
    if (uri.pathSegments.isEmpty) {
      return AppState(page: PageType.home);
    }

    // Xử lý trang settings
    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == 'settings') {
      return AppState(page: PageType.settings);
    }

    // Xử lý trang details
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'details') {
      return AppState(page: PageType.details, itemId: uri.pathSegments[1]);
    }

    // Mặc định trở về trang chủ
    return AppState(page: PageType.home);
  }

  @override
  RouteInformation? restoreRouteInformation(AppState configuration) {
    if (configuration.page == PageType.home) {
      return RouteInformation(uri: Uri.parse('/'));
    }
    if (configuration.page == PageType.settings) {
      return RouteInformation(uri: Uri.parse('/settings'));
    }
    if (configuration.page == PageType.details && configuration.itemId != null) {
      return RouteInformation(uri: Uri.parse('/details/${configuration.itemId}'));
    }
    return null;
  }
}

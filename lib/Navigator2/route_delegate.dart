// Router delegate xử lý điều hướng trong ứng dụng
import 'package:flutter/material.dart';
import 'appstate.dart';
import 'main.dart';

class MyRouterDelegate extends RouterDelegate<AppState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppState> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  AppState appState;
  final Function(AppState) onNewRoutePath;

  MyRouterDelegate({required this.appState, required this.onNewRoutePath});

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<bool> popRoute() async {
    if (appState.page != PageType.home) {
      onNewRoutePath(AppState(page: PageType.home));
      return true;
    }
    return false;
  }

  @override
  AppState get currentConfiguration => appState;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        // Trang chủ luôn hiển thị đầu tiên
        MaterialPage(
          key: ValueKey('HomePage'),
          child: HomePage(
            onItemTapped: (String itemId) {
              onNewRoutePath(appState.copyWith(page: PageType.details, itemId: itemId));
            },
            onSettingsTapped: () {
              onNewRoutePath(appState.copyWith(page: PageType.settings, clearItemId: true));
            },
          ),
        ),
        // Nếu đang ở trang details, thêm trang này vào stack
        if (appState.page == PageType.details && appState.itemId != null)
          MaterialPage(
            key: ValueKey('DetailsPage-${appState.itemId}'),
            child: DetailsPage(
              itemId: appState.itemId!,
              onBackPressed: () {
                onNewRoutePath(appState.copyWith(page: PageType.home, clearItemId: true));
              },
            ),
          ),
        // Nếu đang ở trang settings, thêm trang này vào stack
        if (appState.page == PageType.settings)
          MaterialPage(
            key: ValueKey('SettingsPage'),
            child: SettingsPage(
              onBackPressed: () {
                onNewRoutePath(appState.copyWith(page: PageType.home, clearItemId: true));
              },
            ),
          ),
      ],
      onDidRemovePage: (details) {
        // Xử lý việc trang bị xóa dựa vào context của trang
        final Type pageType = details.name.runtimeType;
        // Xác định trang nào đã bị xóa dựa trên kiểu trang
        if (pageType == MaterialPage) {
          final page = details.name as MaterialPage;

          // Kiểm tra page key để xác định đó là trang nào
          final keyString = (page.key as ValueKey).value.toString();

          if (keyString.startsWith('DetailsPage-') || keyString == 'SettingsPage') {
            // Khi trang details hoặc settings bị xóa, chuyển về trang chủ
            onNewRoutePath(AppState(page: PageType.home));
          }
        }
      },
    );
  }
  @override
  Future<void> setNewRoutePath(AppState configuration) async {
    onNewRoutePath(configuration);
  }
}


// Định nghĩa các loại trang trong ứng dụng
enum PageType { home, details, settings }

// Định nghĩa đối tượng lưu trữ trang hiện tại
class AppState {
  final PageType page;
  final String? itemId;

  AppState({required this.page, this.itemId});

  AppState copyWith({PageType? page, String? itemId, bool? clearItemId}) {
    return AppState(
      page: page ?? this.page,
      itemId: clearItemId == true ? null : (itemId ?? this.itemId),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() {
  runApp(const MaterialApp(
    home: Example(),
  ));
}

class Object {
  int index;
  bool isChecked;

  Object(this.index, this.isChecked);
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<StatefulWidget> createState() {
    return ExampleState();
  }
}

class ExampleState extends State<Example> {
  final scrollOffset = ScrollOffset();
  late ScrollController _scrollController;

  Map<int, bool> checkedItems = {};
  List<Object> items = List.generate(10, (index)=> Object(index,false));
  bool isLoading = false;
  bool hasMoreItems = true;
  int maxItems = 34;
  bool isShowButton = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: scrollOffset.offset);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 300 && !isShowButton) {
      setState(() {
        isShowButton = true;
      });
    } else if (_scrollController.offset <= 300 && isShowButton) {
      setState(() {
        isShowButton = false;
      });
    }
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 30 &&
        !isLoading &&
        hasMoreItems) {
      _loadMoreData();
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(seconds: 2), curve: Curves.easeInOut);
  }

  Future<void> _loadMoreData() async {
    if (!hasMoreItems || isLoading) return;
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    int remainingItems = maxItems - items.length;
    int loadItem = remainingItems > 10 ? 10 : remainingItems;
    if (items.length < maxItems) {
      List<Object> newItems = List.generate(loadItem, (index) => Object(index, false));
      setState(() {
        items.addAll(newItems);
      });
    }
    setState(() {
      isLoading = false;
      if (items.length >= maxItems) {
        hasMoreItems = false;
      }
    });
  }

  @override
  void dispose() {
    scrollOffset.offset = _scrollController.offset;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const SortableCheckList()));
                },
                icon: const Icon(Icons.arrow_right_alt_sharp))
          ],
        ),
        body: buildPageItem());
  }

  Widget buildPageItem() {
    return Stack(
      children: [
        ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            height: 40,
          ),
          controller: _scrollController,
          itemCount: items.length + (hasMoreItems ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < items.length) {
              return CheckboxListTile(
                title: Text("Title ${index + 1}"),
                value: items[index].isChecked,
                onChanged: (value) {
                  setState(() {
                    items[index].isChecked = value ?? false;
                  });
                },
              );
            } else if (hasMoreItems) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center();
          },
        ),
        if (isShowButton)
          Positioned(
            top: 5,
            left: MediaQuery.of(context).size.width / 2 - 20,
            child: GestureDetector(
              onTapDown: (_) => _scrollToTop(),
              child: SvgPicture.asset(
                'assets/AppMovie/icon_uptop.svg',
                height: 30,
              ),
            ),
          ),
      ],
    );
  }
}

class PageViewWithScrollPreservation extends StatelessWidget {
  const PageViewWithScrollPreservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scroll giữ nguyên bằng PageStorageKey')),
      body: PageView(
        children: const [
          CustomListPage(tabIndex: 0),
          CustomListPage(tabIndex: 1),
          CustomListPage(tabIndex: 2),
        ],
      ),
    );
  }
}

class CustomListPage extends StatelessWidget {
  final int tabIndex;

  const CustomListPage({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PageStorageKey('listview_tab_$tabIndex'), // Mỗi tab có key riêng
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text('$tabIndex')),
          title: Text('Tab $tabIndex - Item $index'),
        );
      },
    );
  }
}

class ScrollOffset {
  double offset = 0.0;
}

class SortableCheckList extends StatefulWidget {
  const SortableCheckList({super.key});

  @override
  State<SortableCheckList> createState() => _SortableCheckListState();
}

class _SortableCheckListState extends State<SortableCheckList> {
  List<Item> items = [
    Item(id: 1, name: 'Banana'),
    Item(id: 2, name: 'Apple'),
    Item(id: 3, name: 'Cherry'),
    Item(id: 4, name: 'Date'),
    Item(id: 5, name: 'Elderberry'),
  ];

  Set<int> checkedItemIds = {};
  bool sortAZ = true;

  void toggleCheck(Item item, bool? isChecked) {
    setState(() {
      if (isChecked == true) {
        checkedItemIds.add(item.id);
      } else {
        checkedItemIds.remove(item.id);
      }
    });
  }

  void sortItems() {
    setState(() {
      if (sortAZ) {
        items.sort((a, b) => a.name.compareTo(b.name));
      } else {
        items.sort((a, b) => b.name.compareTo(a.name));
      }
      sortAZ = !sortAZ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sortable Checkbox List'),
        actions: [
          IconButton(
            icon: Icon(sortAZ ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: sortItems,
            tooltip: sortAZ ? "Sort A-Z" : "Sort Z-A",
          ),
          IconButton(
              onPressed: () {
                (Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ComplexLayoutScrollDemo(),
                    )));
              },
              icon: const Icon(Icons.arrow_right))
        ],
      ),
      body: ListView(
        children: items.map((item) {
          return CheckboxListTile(
            title: Text(item.name),
            value: checkedItemIds.contains(item.id),
            onChanged: (val) => toggleCheck(item, val),
          );
        }).toList(),
      ),
    );
  }
}

class ComplexLayoutScrollDemo extends StatefulWidget {
  const ComplexLayoutScrollDemo({super.key});

  @override
  ComplexLayoutScrollDemoState createState() => ComplexLayoutScrollDemoState();
}

class ComplexLayoutScrollDemoState extends State<ComplexLayoutScrollDemo> {
  final scrollState = ScrollOffset();
  late ScrollController _scrollController;

  final ItemPositionsListener _positionsListener = ItemPositionsListener.create();
  final TextEditingController _gotoController = TextEditingController();

  void _scrollToIndex(int index) {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildItem(int index) {
    // Giả lập item với chiều cao khác nhau
    final height = 60.0 + (index % 5) * 30.0;
    return Container(
      height: height,
      padding: const EdgeInsets.all(12),
      color: index % 2 == 0 ? Colors.grey.shade300 : Colors.grey.shade100,
      child: Text("Item $index - height: $height", style: const TextStyle(fontSize: 18)),
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: scrollState.offset);
    print(scrollState.offset.toString());
    super.initState();
  }

  @override
  void dispose() {
    print(_scrollController.offset.toString());

    scrollState.offset = _scrollController.offset;

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scroll To Item - Layout Phức Tạp")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gotoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Nhập index"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final index = int.tryParse(_gotoController.text);
                    if (index != null) {
                      _scrollToIndex(index);
                    }
                  },
                  child: const Text("Go"),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 100,
              itemBuilder: (_, index) => _buildItem(index),
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollbarWithController extends StatefulWidget {
  const ScrollbarWithController({super.key});

  @override
  State<ScrollbarWithController> createState() => _ScrollbarWithControllerState();
}

class _ScrollbarWithControllerState extends State<ScrollbarWithController> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kéo thanh cuộn nhanh")),
      body: Scrollbar(
        controller: _scrollController,
        thickness: 12,
        interactive: true,
        radius: const Radius.circular(10),
        thumbVisibility: true,
        // Hiện thanh cuộn ngay từ đầu
        child: ListView.builder(
          controller: _scrollController,
          itemCount: 100, // Giả lập danh sách dài
          itemBuilder: (context, index) => ListTile(
            title: Text("Item $index"),
          ),
        ),
      ),
    );
  }
}

class RefreshListView extends StatefulWidget {
  const RefreshListView({super.key});

  @override
  RefreshListViewState createState() => RefreshListViewState();
}

class RefreshListViewState extends State<RefreshListView> {
  List<String> items = List.generate(10, (index) => "Item ${index + 1}");

  // Hàm làm mới danh sách
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2)); // Giả lập tải dữ liệu từ API
    setState(() {
      items = List.generate(10, (index) => "Item mới ${index + 1}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pull to Refresh ListView")),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
              leading: const Icon(Icons.refresh),
            );
          },
        ),
      ),
    );
  }
}

class PullToRefreshWithCheckbox extends StatefulWidget {
  const PullToRefreshWithCheckbox({super.key});

  @override
  State<PullToRefreshWithCheckbox> createState() => _PullToRefreshWithCheckboxState();
}

class _PullToRefreshWithCheckboxState extends State<PullToRefreshWithCheckbox> {
  final List<int> allItems = List.generate(20, (index) => index + 1); // 20 item có sẵn
  List<int> displayedItems = []; // Danh sách 10 item ngẫu nhiên
  final Map<int, bool> checkedItems = {}; // Trạng thái checkbox của từng item
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _loadRandomItems(); // Lần đầu load danh sách 10 item
  }

  // Chọn ngẫu nhiên 10 item từ danh sách gốc
  void _loadRandomItems() {
    setState(() {
      displayedItems = List.from(allItems)..shuffle(random);
      displayedItems = displayedItems.take(10).toList();
    });
  }

  // Giữ trạng thái checkbox khi làm mới danh sách
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2)); // Giả lập thời gian tải
    _loadRandomItems(); // Cập nhật danh sách 10 item ngẫu nhiên
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pull to Refresh with Checkbox")),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: displayedItems.length,
          itemBuilder: (context, index) {
            int item = displayedItems[index];
            return ListTile(
              title: Text("Item $item"),
              leading: Checkbox(
                value: checkedItems[item] ?? false, // Giữ trạng thái checkbox
                onChanged: (bool? value) {
                  setState(() {
                    checkedItems[item] = value ?? false; // Cập nhật trạng thái
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

//lọc dữ liệu
class Book {
  final String title;
  final String genre;

  Book(this.title, this.genre);
}

class BookFilterScreen extends StatefulWidget {
  const BookFilterScreen({super.key});

  @override
  State<BookFilterScreen> createState() => _BookFilterScreenState();
}

class _BookFilterScreenState extends State<BookFilterScreen> {
  final List<Book> allBooks = [
    Book("Cuộc Sống Kinh Dị", "Kinh Dị"),
    Book("Chạng Vạng", "Lãng Mạn"),
    Book("Ma Quái", "Kinh Dị"),
    Book("Tình Yêu Vĩnh Cửu", "Lãng Mạn"),
    Book("Bóng Tối", "Kinh Dị"),
    Book("Hẹn Hò Nơi Paris", "Lãng Mạn"),
  ];

  String selectedGenre = "Tất Cả"; // Lưu bộ lọc hiện tại

  @override
  Widget build(BuildContext context) {
    List<Book> filteredBooks = selectedGenre == "Tất Cả"
        ? allBooks
        : allBooks.where((book) => book.genre == selectedGenre).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Lọc Sách")),
      body: Column(
        children: [
          // Bộ lọc thể loại
          DropdownButton<String>(
            value: selectedGenre,
            onChanged: (String? newGenre) {
              if (newGenre != null) {
                setState(() {
                  selectedGenre = newGenre;
                });
              }
            },
            items: ["Tất Cả", "Kinh Dị", "Lãng Mạn"]
                .map((genre) => DropdownMenuItem(
                      value: genre,
                      child: Text(genre),
                    ))
                .toList(),
          ),
          Expanded(
            child: filteredBooks.isEmpty
                ? const Center(child: Text("Không có sách nào phù hợp"))
                : ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredBooks[index].title),
                        subtitle: Text(filteredBooks[index].genre),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

//chuyển dạng listview- gridview
class ToggleViewExample extends StatefulWidget {
  const ToggleViewExample({super.key});

  @override
  ToggleViewExampleState createState() => ToggleViewExampleState();
}

class ToggleViewExampleState extends State<ToggleViewExample> {
  bool isGridView = false;
  List<Item> items = List.generate(20, (index) => Item(id: index, name: "Item $index"));
  Map<int, bool> selectedItems = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toggle List/Grid View"),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          )
        ],
      ),
      body: isGridView ? buildGridView() : buildListView(),
    );
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return buildItem(items[index]);
      },
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cột
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return buildItem(items[index]);
      },
    );
  }

  Widget buildItem(Item item) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: selectedItems[item.id] ?? false,
          onChanged: (bool? value) {
            setState(() {
              selectedItems[item.id] = value!;
            });
          },
        ),
        title: Text(item.name),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class Item {
  final int id;
  final String name;

  Item({required this.id, required this.name});
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final List<int> movies = List.generate(20, (index) => index + 1);
  final Map<int, bool> likedMovies = {}; // Lưu trạng thái đã tym
  final ScrollController _controller = ScrollController();
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(_scrollController);
    super.initState();
  }

  void _scrollController() {
    if (!isLoading) {
      loadMoreData();
    }
  }

  void toggleLike(int index) {
    setState(() {
      likedMovies[index] = !(likedMovies[index] ?? false);
    });
  }

  Future<void> loadMoreData() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    List<int> newList = List.generate(10, (index) => movies.length + index + 1);
    if (movies.length >= 50) {
      setState(() {
        hasMoreData = false;
      });
    } else {
      movies.addAll(newList);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh Sách Phim")),
      body: ListView.builder(
          controller: _controller,
          itemCount: movies.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            bool isLiked = likedMovies[index] ?? false;
            if (index < movies.length) {
              return ListTile(
                title: Text("phim ${movies[index]}"),
                trailing: GestureDetector(
                  onTap: () => toggleLike(index),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(isLiked),
                      // Đảm bảo animation hoạt động đúng
                      color: isLiked ? Colors.red : Colors.grey,
                      size: 30,
                    ),
                  ),
                ),
              );
            } else if (hasMoreData) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ));
            }
            return const Center();
          }),
    );
  }
}

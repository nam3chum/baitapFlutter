import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swapify/App%20Movie%20Film/model.dart';

class ListFilm extends StatefulWidget {
  final Future<MovieResponse> listFilm;

  const ListFilm({super.key, required this.listFilm});

  @override
  State<ListFilm> createState() => _ListFilmState();
}

class _ListFilmState extends State<ListFilm> {
  List<int> items = List.generate(10, (index) => index);
  final ScrollController controller1 = ScrollController();
  bool isLoadingMore = false;
  bool isShowButton = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1.addListener(onScroller1);
  }

  void onScroller1() {
    if (controller1.offset > 200 && !isShowButton) {
      setState(() {
        isShowButton = true;
      });
    } else if (controller1.offset <= 200 && isShowButton) {
      setState(() => isShowButton = false);
    }
  }

  void _scrollToTop() {
    double currentOffset = controller1.offset;
    double scrollDuration = (currentOffset / 1000).clamp(0.8, 1.3);
    controller1
        .animateTo(
      0,
      duration: Duration(milliseconds: scrollDuration.toInt()),
      curve: Curves.easeOut,
    )
        .then((_) {
      setState(() {
        isShowButton = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
            backgroundColor: const Color(0xff716850),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xff716850),
              title: const Text(
                "Trending",
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
            ),
            body: FutureBuilder(
              future: widget.listFilm,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData ||
                    snapshot.data!.results.isEmpty) {
                  return const Center(child: Text("No data available."));
                }
                final movies = snapshot.data!.results;
                return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Stack(
                      children: [
                        ListView.separated(
                          controller: controller1,
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 20,
                            );
                          },
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return Item(
                              imgPoster: movie.posterPath,
                              title: movie.title,
                              overView: movie.overview,
                              voteAverage: movie.voteAverage,
                              voteCount: movie.voteCount,
                              //calculateVote: calculateVote,
                            );
                          },
                        ),
                        if (isShowButton)
                          Positioned(
                              top: 5,
                              left: MediaQuery.of(context).size.width / 2 - 20,
                              child: GestureDetector(
                                  onTapDown: (_) {
                                    setState(() {
                                      _scrollToTop;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/AppMovie/icon_uptop.svg',
                                    height: 30,
                                  )))
                      ],
                    ));
              },
            ));
      },
    );
  }
}

class Item extends StatefulWidget {
  final String imgPoster;
  final String title;
  final String overView;
  final double voteAverage;
  final int voteCount;

  const Item(
      {super.key,
      //required this.calculateVote,
      required this.imgPoster,
      required this.title,
      required this.overView,
      required this.voteAverage,
      required this.voteCount});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool isClick = false;
  late int initialVoteCount;

  int calculateStars(double voteAverage) {
    if (voteAverage <= 1) return 0;
    if (voteAverage > 1 && voteAverage <= 3) return 1;
    if (voteAverage > 3 && voteAverage <= 5) return 2;
    if (voteAverage > 5 && voteAverage <= 7) return 3;
    if (voteAverage > 7 && voteAverage <= 9) return 4;
    return 5;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialVoteCount = widget.voteCount;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 130,
          width: 100,
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                offset: Offset(5, 5),
                color: Colors.black26,
                blurRadius: 5,
                blurStyle: BlurStyle.normal,
                spreadRadius: 3)
          ], borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500${widget.imgPoster}",
                fit: BoxFit.fill,
              )),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 150,
              child: Text(widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 2),
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              children: List.generate(5, (index) {
                int stars = calculateStars(widget.voteAverage);
                return Icon(Icons.star,
                    color: index < stars == true
                        ? Colors.yellowAccent
                        : Colors.grey,
                    size: 15);
              }),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              height: 70,
              width: 180,
              child: Text(
                widget.overView,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isClick = !isClick;
                  });
                  if (isClick) {
                    initialVoteCount += 1;
                  } else {
                    initialVoteCount -= 1;
                  }
                },
                child: SvgPicture.asset(
                  'assets/AppMovie/heart.svg',
                  width: 15,
                  height: 15,
                  colorFilter: ColorFilter.mode(
                      isClick == true ? const Color(0xffbb7152) : Colors.grey,
                      BlendMode.srcIn),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                initialVoteCount.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )
            ],
          ),
        ))
      ],
    );
  }
}

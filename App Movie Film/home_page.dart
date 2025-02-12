import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swapify/App%20Movie%20Film/list_film_page.dart';
import 'package:swapify/App%20Movie%20Film/model.dart';
import 'package:swapify/App%20Movie%20Film/search_page.dart';

final List<int> countIndex = [0, 1, 2, 3, 4, 5];

void main() {
  runApp(const MaterialApp(
    home: TrangChu(),
  ));
}

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => TrangChuState();
}

class TrangChuState extends State<TrangChu> {
  PageController pageController = PageController(initialPage: 0);
  int indexOfPage = 0;
  int posterIndex = 0;

  void searchAction() {
    setState(() {
      PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SearchPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    Future<MovieResponse> loadTrendingMovies() async {
      final String response =
          await rootBundle.loadString('assets/trending_1.json');
      final data = json.decode(response);
      return MovieResponse.fromJson(data);
    }

    return Scaffold(
      backgroundColor: const Color(0xff716850),
      appBar: AppBar(
        backgroundColor: const Color(0xff716850),
        title: const Text(
          'Trending',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        actions: [
          Visibility(
            visible: indexOfPage != 1,
            child: IconButton(
                color: Colors.black,
                onPressed: searchAction,
                icon: const Icon(
                  Icons.search,
                  size: 40,
                )),
          )
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            indexOfPage = value;
          });
        },
        children: [
          Home(
            movieTrending: loadTrendingMovies(),
          ),
          MovieFilm(
            trendingMovies: loadTrendingMovies(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height / 11,
        decoration: const BoxDecoration(color: Color(0xff716850), boxShadow: [
          BoxShadow(
              offset: Offset(0, -5),
              color: Colors.black26,
              blurRadius: 10,
              blurStyle: BlurStyle.normal,
              spreadRadius: 3)
        ]),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(
            iconSize: 40,
            icon: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: indexOfPage == 0 ? 1.2 : 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Icon(
                Icons.home,
                color: indexOfPage == 0 ? Colors.red : Colors.grey,
              ),
            ),
            onPressed: () {
              setState(() {
                indexOfPage = 0;
              });
              pageController.jumpToPage(0);
            },
          ),
          IconButton(
            iconSize: 40,
            icon: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: indexOfPage == 1 ? 1.2 : 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: SvgPicture.asset(
                  "assets/AppMovie/movie_icon.svg",
                  colorFilter: ColorFilter.mode(
                      indexOfPage == 1 ? Colors.red : Colors.grey,
                      BlendMode.srcIn),
                )),
            onPressed: () {
              setState(() {
                indexOfPage = 1;
              });
              pageController.jumpToPage(1);
            },
          )
        ]),
      ),
    );
  }
}

class MovieFilm extends StatelessWidget {
  final Future<MovieResponse> trendingMovies;

  const MovieFilm({super.key, required this.trendingMovies});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<MovieResponse>(
      future: trendingMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
          return const Center(child: Text("No data available."));
        }
        final movies = snapshot.data!.results;
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 20, childAspectRatio: 0.7),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Padding(
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  final Future<MovieResponse> movieTrending;

  const Home({super.key, posterIndex, required this.movieTrending});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int posterIndex = 0;
  late PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        PageController(viewportFraction: 0.6, initialPage: posterIndex);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // TODO: implement build
    return FutureBuilder<MovieResponse>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
          return const Center(child: Text("No data available."));
        }
        final movies = snapshot.data!.results;
        return SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: size.height / 2.2,
                  width: size.width,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return PageView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 6,
                        onPageChanged: (value) {
                          setState(() {
                            posterIndex = value;
                          });
                        },
                        controller: controller,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          double scale = 1;
                          if (controller.position.haveDimensions) {
                            double page = controller.page ?? 0;
                            scale = (1 - (page - index).abs() * 0.2)
                                .clamp(0.6, 1.0);
                          } else {
                            scale = index == 0 ? scale : 0.8;
                          }
                          return Transform.scale(
                            scale: scale,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 5),
                                            color: Colors.black26,
                                            blurRadius: 8,
                                            blurStyle: BlurStyle.normal,
                                            spreadRadius: 1)
                                      ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.network(
                                      "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                )),
                          );
                        },
                      );
                    },
                  )),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(countIndex.length, (index) {
                    return _NextPageView(isSelected: posterIndex == index);
                  }),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ListFilm(listFilm: widget.movieTrending),
                            ));
                      });
                    },
                    child: const Text(
                      textAlign: TextAlign.left,
                      'List of day',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  )),
              const SizedBox(height: 5),

              /// List of day
              Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                padding: const EdgeInsets.only(bottom: 50),
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Image.network(
                        "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        );
      },
      future: widget.movieTrending,
    );
  }
}

class _NextPageView extends StatelessWidget {
  final bool isSelected;

  const _NextPageView({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: isSelected
            ? const Icon(size: 20, Icons.circle, color: Colors.red)
            : const Icon(size: 20, color: Color(0xffe3a2a2), Icons.circle));
  }
}

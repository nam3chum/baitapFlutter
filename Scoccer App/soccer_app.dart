import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(const MaterialApp(
    color: Color(0xFF010723),
    home: SoccerApp(),
  ));
}

class SoccerApp extends StatefulWidget {
  const SoccerApp({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SoccerAppState();
  }
}

Map<String, List<String>> data = {
  "Create Profile": [
    'assets/SoccerAppPageView/svg1.png',
    'Create Profile',
    'Show what a sports enthusiast you are!'
  ],
  "Join Games": [
    'assets/SoccerAppPageView/svg2.svg',
    'Join Games',
    'Discover football events and fixtures'
  ],
  "Earn Bagde": [
    'assets/SoccerAppPageView/svg3.png',
    'Earn Bagde',
    'Don’t drop your guard. Be copetitive and get highly rated by your teammates to earn badges. The road to excel in career is here.'
  ],
  "Stand out from the crowd": [
    'assets/SoccerAppPageView/svg4.png',
    'Stand out from the crowd',
    'Get reviewed and win free ticket to membership of the clubs!'
  ],
  "Sign Up": [
    'assets/SoccerAppPageView/svg5.svg',
    'Sign Up',
    'Get started to make a new play buddy!'
  ]
};
List<String> listKey = data.keys.toList();

class SoccerAppState extends State<SoccerApp> {
  int selected = 0;
  bool checkSvg = true;
  final PageController _pageController = PageController(initialPage: 0);

  bool checkSVG(String svgPath) {
    return svgPath.contains('.svg');
  }

  void onPageChange(int index) {
    setState(() => selected = index);
    // if (index == data.length + 1) {
    //   Future.delayed(const Duration(milliseconds: 300), () {
    //     _pageController.jumpToPage(1);
    //   });
    // }
    // if (index == 0) {
    //   Future.delayed(const Duration(milliseconds: 300), () {
    //     _pageController.jumpToPage(duLieu.length);
    //   });
    // }
  }

  void handleCategoryButtonPress(int index) {
    setState(() {
      selected = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFF010723),
      body: Column(
        children: [
          Expanded(
              child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            onPageChanged: (index) {
              onPageChange(index);
            },
            itemCount: data.length,
            itemBuilder: (context, index) {
              List<String>? listPath = data[listKey[index]];
              checkSvg = checkSVG(listPath![0]);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: _PageView(
                    svgPath: listPath[0],
                    title: data.containsKey(listKey[index]) ? listKey[index] : '',
                    view: listPath[2],
                    svgCheck: checkSvg),
              );
            },
          )),
          SizedBox(
            height: MediaQuery.of(context).size.height / 8,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    selected--;
                    if (selected <= 0) {
                      selected = 0;
                    }
                    handleCategoryButtonPress(selected);
                  },
                  child: Visibility(
                    visible: selected != 0,
                    // Hiển thị hoặc ẩn widget
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: SvgPicture.asset(
                      "assets/SoccerAppPageView/NextLeft.svg",
                      height: 75,
                      width: 75,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(countIndex.length, (index) {
                        return _NextPageView(isSelected: selected == index);
                      }),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      selected++;
                      if (selected >= countIndex.length - 1) {
                        selected = countIndex.length - 1;
                      }
                      handleCategoryButtonPress(selected);
                    },
                    icon: SvgPicture.asset(
                      'assets/SoccerAppPageView/NextRight.svg',
                      width: 75,
                      height: 75,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

final List<int> countIndex = [1, 2, 3, 4, 5];

class _NextPageView extends StatelessWidget {
  final bool isSelected;

  const _NextPageView({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: isSelected
            ? const Icon(size: 13, Icons.circle, color: Color(0xFF0448D8))
            : const Icon(size: 13, color: Color(0xff778595), Icons.circle_outlined));
  }
}

class _PageView extends StatelessWidget {
  final String svgPath;
  final String title;
  final String view;
  final bool svgCheck;

  const _PageView(
      {required this.svgPath, required this.title, required this.view, required this.svgCheck});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: svgCheck
                ? (SvgPicture.asset(
                    svgPath,
                    fit: BoxFit.cover,
                  ))
                : Image.asset(
                    svgPath,
                    fit: BoxFit.cover,
                  )),
        Expanded(
            child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold, height: 1),
                    maxLines: 2,
                  ),
                ],
              ),
              AutoSizeText(
                view,
                style: const TextStyle(fontSize: 17, color: Color(0xFF778595)),
                maxLines: 6,
              )
            ],
          ),
        ))
      ],
    );
  }
}

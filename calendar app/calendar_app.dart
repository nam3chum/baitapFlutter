import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MaterialApp(
    home: Calendar(),
  ));
}

// Tháng 1: January – Jan
// Tháng 2: February – Feb
// Tháng 3: March – Mar
// Tháng 4: April – Apr
// Tháng 5: May – May
// Tháng 6: June – Jun
// Tháng 7: July – Jul
// Tháng 8: August – Aug
// Tháng 9: September – Sep
// Tháng 10: October – Oct
// Tháng 11: November – Nov
// Tháng 12: December – Dec
Map<int, String> listMonth = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: " August",
  9: "September",
  10: "October",
  11: "November",
  12: "December"
};

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {
  final PageController _pageAppController = PageController(initialPage: 1);
  int indexOfAppPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff2a304d),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    indexOfAppPage = 0;
                    _pageAppController.animateToPage(0,
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.linear);
                  });
                },
                icon: SvgPicture.asset(
                  'assets/CalendarApp/page1.svg',
                  colorFilter: ColorFilter.mode(
                      indexOfAppPage == 0
                          ? Colors.white
                          : const Color(0xffC2C8E6).withOpacity(0.2),
                      BlendMode.modulate),
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      indexOfAppPage = 1;
                      _pageAppController.animateToPage(1,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.linear);
                    });
                  },
                  color: indexOfAppPage == 1
                      ? Colors.white
                      : const Color(0xffC2C8E6).withOpacity(0.2),
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      indexOfAppPage = 2;
                      _pageAppController.animateToPage(2,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.linear);
                    });
                  },
                  icon: Icon(
                    Icons.bar_chart,
                    color: indexOfAppPage == 2
                        ? Colors.white
                        : const Color(0xffC2C8E6).withOpacity(0.2),
                  ))
            ],
          ),
        ),
        backgroundColor: const Color(0xff2a304d),
        body: PageView(
          controller: _pageAppController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            setState(() {
              indexOfAppPage = index;
            });
          },
          children: [
            //page 1
            const Center(
              child: Text(
                "this is page 1",
                style: TextStyle(color: Colors.white),
              ),
            ),
            // page calendar
            const CalendarPage(),
            //page bar_chart
            BalancePage(),
          ],
        ));
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CalendarPage> {
  DateTime date = DateTime.now();
  Map<DateTime, int> selectedDays = {};
  final weekDays = ["M", "T", "W", "T", "F", "S", "S"];
  late final PageController tableCalendarController;

  void toggleDayColor(DateTime day) {
    setState(() {
      if (!selectedDays.containsKey(day)) {
        selectedDays[day] = 1;
      } else {
        selectedDays[day] = (selectedDays[day]! + 1) % 4;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tableCalendarController = PageController(
        initialPage: monthDifference(DateTime(2000, 1, 1), date));
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<DateTime?> daysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);

    final days = List.generate(
        lastDay.day, (i) => DateTime(date.year, date.month, i + 1));
    int firstWeekday = (firstDay.weekday - 1) % 7;
    final emptyStart = List<DateTime?>.filled(firstWeekday, null);
    final totalDays = emptyStart + days;
    final emptyEnd = List<DateTime?>.filled(42 - totalDays.length, null);
    return totalDays + emptyEnd;
  }

  DateTime getDateFromIndex(int index) {
    final initDate = DateTime(2000, 1, 1);
    return DateTime(initDate.year + (index ~/ 12), (index % 12) + 1, 1);
  }

  int monthDifference(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2c3251), // Nền tối
      body: Column(
        children: [
          Container(
            color: const Color(0xff2a304d),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      final currentPage = tableCalendarController.page!;
                      tableCalendarController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceInOut,
                      );
                      date = getDateFromIndex((currentPage - 1) as int);
                    });
                  },
                ),
                Text(
                  "${listMonth[date.month].toString().toUpperCase()} ${date.year}",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      final currentPage = tableCalendarController.page!;
                      tableCalendarController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      date = getDateFromIndex((currentPage + 1) as int);
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                // Header ngày trong tuần
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: const Color(0xff2a304d),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: weekDays
                        .map((day) => Expanded(
                              child: Text(
                                day,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                //table ngày trong tháng
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: PageView.builder(
                    controller: tableCalendarController,
                    onPageChanged: (index) {
                      setState(() {
                        date = getDateFromIndex(index);
                      });
                    },
                    itemBuilder: (context, index) {
                      final currentMonth = getDateFromIndex(index);
                      final days = daysInMonth(currentMonth);
                      return SizedBox(
                          child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1,
                                childAspectRatio: 1.25),
                        itemCount: days.length,
                        itemBuilder: (context, index) {
                          final day = days[index];
                          bool isToday =
                              day != null && isSameDay(day, DateTime.now());
                          int colorState = selectedDays[day] ?? 0;
                          Color bgColor;
                          if (colorState == 1) {
                            bgColor = const Color(0xff587d97);
                          } else if (colorState == 2) {
                            bgColor = const Color(0xff3d516d);
                          } else if (colorState == 3) {
                            bgColor = const Color(0xff364160);
                          } else {
                            bgColor = Colors.transparent;
                          }
                          return GestureDetector(
                            onTap: () {
                              if (day != null) {
                                toggleDayColor(day);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isToday ? Colors.white : bgColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                day != null ? '${day.day}' : '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isToday
                                      ? Colors.black
                                      : colorState > 0
                                          ? Colors.white
                                          : const Color(0xff666b88),
                                ),
                              ),
                            ),
                          );
                        },
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
          //payment
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: const [
                NewPayment(
                  colorIcon: Color(0xff9B7EF8),
                  title: "Electricity Bill",
                  behavior: "every month",
                  bill: "108",
                  isIcon: false,
                ),
                NewPayment(
                  isIcon: false,
                  title: "DropBox Subscription",
                  bill: " 9.99",
                  behavior: "every month",
                  colorIcon: Color(0xffE2E289),
                ),
                NewPayment(
                  isIcon: true,
                  bill: "0",
                  behavior: "schedule new payment",
                  colorIcon: Colors.grey,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: 40,
                        height: 40,
                        child: SvgPicture.asset(
                          'assets/CalendarApp/ovalicon.svg',
                        )),
                    const Text(
                      "All Categories",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff7FCFDC),
                          fontFamily: "Roboto"),
                    ),
                  ],
                ),
                const Text(
                  r'$' "117.99",
                  style: TextStyle(color: Color(0xff7FCFDC), fontSize: 20),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewPayment extends StatelessWidget {
  final String title;
  final String behavior;
  final Color colorIcon;
  final String bill;
  final bool isIcon;

  const NewPayment(
      {this.title = "",
      required this.isIcon,
      required this.bill,
      required this.behavior,
      required this.colorIcon,
      super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: 15,
                      height: 15,
                      decoration: isIcon
                          ? null
                          : ShapeDecoration(
                              color: colorIcon,
                              shape: const CircleBorder(
                                  side: BorderSide(color: Colors.black)),
                            ),
                      child: Visibility(
                          visible: isIcon,
                          child: SvgPicture.asset(
                            'assets/CalendarApp/iconpayment.svg',
                            height: 17,
                            width: 17,
                          ))),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: !isIcon,
                            child: Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        Text(
                          behavior,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff6c718e),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                !isIcon ? r'$' "$bill" : " ",
                style: const TextStyle(color: Color(0xff7FCFDC), fontSize: 20),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Visibility(
          visible: !isIcon,
          child: Container(
            margin: const EdgeInsets.only(left: 50),
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class BalancePage extends StatelessWidget {
  final DateTime selectedDate = DateTime.now();

  BalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //thông tin
        Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 30, top: 50, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Balance",
                        style: TextStyle(fontSize: 45, color: Colors.white),
                      ),
                      //ngày tháng được chọn bên tab calendar
                      Text(
                        '${listMonth[selectedDate.month]}, ${selectedDate.day} ${selectedDate.year}',
                        style: const TextStyle(
                            color: Color(0xff757a95), fontSize: 16),
                      )
                    ],
                  ),
                  const Row(
                    children: [
                      //Curent
                      Column(
                        children: [
                          Text(
                            r'$3 580',
                            style: TextStyle(
                                color: Color(0xff7FCFDC), fontSize: 20),
                          ),
                          Text('CURRENT',
                              style: TextStyle(color: Color(0xff7FCFDC)))
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r'$1 220',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                          Text('LAST MONTH',
                              style: TextStyle(color: Colors.grey))
                        ],
                      )
                      //last month
                    ],
                  )
                ],
              )),
        ),
        //biểu đồ xếp chồng
        Container(
          color: const Color(0xff282E4B),
          padding: const EdgeInsets.only(top: 30),
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: SvgPicture.asset(
            'assets/CalendarApp/scratch.svg',
            fit: BoxFit.fill,
          ),
        ),
        Container(
          color: Colors.white,
          height: 5,
          width: MediaQuery.of(context).size.width / 2,
        )
      ],
    );
  }
}

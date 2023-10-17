import 'dart:collection';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workmanager/workmanager.dart';
import '../../api/ru_isuct.dart';
import '../../components/Notification/LocalNotificationService.dart';
import '../../components/Notification/workCallback.dart';
import '../../components/weekNumber.dart';
import '../../custom/customArg.dart';
import '../../main.dart';
import '../../styles/colors.dart';
import '../schedule/lessonsPage.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List> _eventsList = {};
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _eventsList = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseAndGroup.replaceAll("-", "/"),
            style: TextStyle(fontStyle: FontStyle.italic)),
        actions: [
          IconButton(
              onPressed: () async {
                AppMetrica.reportEvent('Уведомление (Календарь)');
                await offlineApi();
                Future.delayed(Duration(seconds: 3), () {});
                service = LocalNotificationService();
                service.intialize();
                listenToNotification();

                Workmanager()
                    .initialize(callbackDispatcher, isInDebugMode: false);
                Workmanager().cancelByTag("2");
                Workmanager().registerOneOffTask(
                  "2",
                  "schedule",
                  initialDelay: Duration(seconds: 2),
                );
              },
              icon: Icon(Icons.notification_add))
        ],
      ),
      body: FutureBuilder(
          future: offlineApi(),
          builder: (context, snapshot) {
            _eventsList = {
              if (!isEmptyData)
                for (int i =
                        DateTime.now().month >= 2 && DateTime.now().month <= 6
                            ? 2
                            : DateTime.now().month >= 9 &&
                                    DateTime.now().month <= 12
                                ? 9
                                : 0;
                    i <=
                        (DateTime.now().month >= 2 && DateTime.now().month <= 6
                            ? 6
                            : DateTime.now().month >= 9 &&
                                    DateTime.now().month <= 12
                                ? 12
                                : 0);
                    ++i)
                  for (int j = 1;
                      j <= DateTime(DateTime.now().year, i + 1, 0).day;
                      j++)
                    if (DateTime(DateTime.now().year, i, j).weekday == DateTime.monday)
                      DateTime(DateTime.now().year, i, j): listlessonsCustom(
                          weekNumber(DateTime(DateTime.now().year, i, j)) % 2 == 0
                              ? 1
                              : 2,
                          1)
                    else if (DateTime(DateTime.now().year, i, j).weekday ==
                        DateTime.tuesday)
                      DateTime(DateTime.now().year, i, j): listlessonsCustom(
                          weekNumber(DateTime(DateTime.now().year, i, j)) % 2 == 0
                              ? 1
                              : 2,
                          2)
                    else if (DateTime(DateTime.now().year, i, j).weekday ==
                        DateTime.wednesday)
                      DateTime(DateTime.now().year, i, j): listlessonsCustom(
                          weekNumber(DateTime(DateTime.now().year, i, j)) % 2 == 0
                              ? 1
                              : 2,
                          3)
                    else if (DateTime(DateTime.now().year, i, j).weekday ==
                        DateTime.thursday)
                      DateTime(DateTime.now().year, i, j):
                          listlessonsCustom(weekNumber(DateTime(DateTime.now().year, i, j)) % 2 == 0 ? 1 : 2, 4)
                    else if (DateTime(DateTime.now().year, i, j).weekday == DateTime.friday)
                      DateTime(DateTime.now().year, i, j): listlessonsCustom(weekNumber(DateTime(DateTime.now().year, i, j)) % 2 == 0 ? 1 : 2, 5)
                    else if (DateTime(DateTime.now().year, i, j).weekday == DateTime.saturday)
                      DateTime(DateTime.now().year, i, j): listlessonsCustom(weekNumber(DateTime(DateTime.now().year, i, j)) % 2 == 0 ? 1 : 2, 6)
            };
            //     List<Lesson> listScheduleToday = [];
            listScheduleToday = (!isEmptyData)
                ? (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                            .weekday ==
                        DateTime.monday)
                    ? listlessonsCustom(
                        weekNumber(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) % 2 == 0
                            ? 1
                            : 2,
                        1)
                    : (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                                .weekday ==
                            DateTime.tuesday)
                        ? listlessonsCustom(
                            weekNumber(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) % 2 == 0
                                ? 1
                                : 2,
                            2)
                        : (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                                    .weekday ==
                                DateTime.wednesday)
                            ? listlessonsCustom(
                                weekNumber(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) % 2 == 0
                                    ? 1
                                    : 2,
                                3)
                            : (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                                        .weekday ==
                                    DateTime.thursday)
                                ? listlessonsCustom(
                                    weekNumber(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) % 2 == 0
                                        ? 1
                                        : 2,
                                    4)
                                : (DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day)
                                            .weekday ==
                                        DateTime.friday)
                                    ? listlessonsCustom(weekNumber(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) % 2 == 0 ? 1 : 2, 5)
                                    : (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).weekday == DateTime.saturday)
                                        ? listlessonsCustom(weekNumber(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) % 2 == 0 ? 1 : 2, 6)
                                        : []
                : [];
            final _events = LinkedHashMap<DateTime, List>(
              equals: isSameDay,
              hashCode: getHashCode,
            )..addAll(_eventsList);

            List _getEventForDay(DateTime day) {
              return _events[day] ?? [];
            }

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(children: [
                TableCalendar(
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle:
                        TextStyle(color: context.textTheme.titleMedium!.color),
                    weekendStyle: TextStyle(
                        color: context.textTheme.titleMedium!.color!
                            .withOpacity(0.5)),
                  ),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  headerStyle: HeaderStyle(
                    formatButtonDecoration: BoxDecoration(
                      border: Border.all(color: colorBlue),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                      outsideTextStyle: TextStyle(
                          color: context.textTheme.titleMedium!.color!
                              .withOpacity(0.5)),
                      todayDecoration: BoxDecoration(
                          color: colorBlue.withOpacity(0.5),
                          shape: BoxShape.circle),
                      markerDecoration: BoxDecoration(
                          color: context.textTheme.titleMedium!.color,
                          shape: BoxShape.circle),
                      selectedDecoration: BoxDecoration(
                        color: colorBlue,
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: TextStyle(
                          color: context.textTheme.titleMedium!.color!
                              .withOpacity(0.5))),
                  firstDay: DateTime.utc(2022, 6, 1),
                  lastDay: DateTime.utc(2100, 6, 1),
                  headerVisible: true,
                  locale: 'ru_RU',
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Месяц',
                    CalendarFormat.twoWeeks: '2 недели',
                    CalendarFormat.week: 'Неделя'
                  },
                  focusedDay: _focusedDay,
                  eventLoader: _getEventForDay,
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        print(weekNumber(selectedDay));
                        _focusedDay = focusedDay;
                      });
                      _getEventForDay(selectedDay);
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: _getEventForDay(_selectedDay!).map((event) {
                      return cardWidget(e: event);
                    }).toList(),
                  ),
                ),
                // ),
              ]),
            );
          }),
    );
  }
}

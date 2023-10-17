import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:my_university_isuct/Pages/schedule/lessonsController.dart';
import '../../api/ru_isuct.dart';
import '../../components/CustomCard.dart';
import '../../components/CustomText.dart';
import '../../custom/customArg.dart';
import '../../model/isuctModel.dart';
import '../../styles/colors.dart';

var controller = Get.put(LessonsController());
List weekend = [
  "Понедельник",
  "Вторник",
  "Среда",
  "Четверг",
  "Пятница",
  "Суббота"
];

class LessonsPage extends GetView<LessonsController> {
  LessonsPage({super.key});
  @override
  Widget build(BuildContext context) {
    AppMetrica.reportEvent(
        'Расписание пар, ориентация экрана ${MediaQuery.of(context).orientation}');
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: getISUCT(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: Text('Press button to start.'));
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const Center(
                      child: Center(child: CircularProgressIndicator()));
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  return Obx(() => RefreshIndicator(
                      color: colorBlue,
                      backgroundColor: context.theme.primaryColor,
                      onRefresh: () async {
                        return controller.onRefresh();
                      },
                      child: ScrollConfiguration(
                          behavior: ScrollBehavior(),
                          child: GlowingOverscrollIndicator(
                              axisDirection: AxisDirection.down,
                              color: colorBlue,
                              child: ListView(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ExpansionPanelList(
                                          expansionCallback:
                                              (panelIndex, isExpanded) {
                                            print("panelIndex : ${panelIndex}");
                                            switch (panelIndex) {
                                              case 0:
                                                controller.week1.value =
                                                    !controller.week1.value;
                                                controller.week2.value = false;
                                                break;
                                              case 1:
                                                controller.week2.value =
                                                    !controller.week2.value;
                                                controller.week1.value = false;
                                                break;
                                              default:
                                                controller.week2.value = false;
                                                controller.week1.value = false;
                                                break;
                                            }
                                          },
                                          children: [
                                            ExpansionPanel(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                headerBuilder:
                                                    (context, isExpand) {
                                                  return const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: CustomText(
                                                        "I неделя",
                                                        fontWeight: true,
                                                      ));
                                                },
                                                isExpanded:
                                                    controller.week1.value,
                                                canTapOnHeader: true,
                                                body: AlignedGridView.count(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  crossAxisSpacing: 8,
                                                  mainAxisSpacing: 4,
                                                  crossAxisCount:
                                                      context.isLandscape
                                                          ? 2
                                                          : 1,
                                                  itemCount: weekend.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        CustomText(
                                                            weekend[index]),
                                                        listWidget(
                                                            ifacult: ifacult,
                                                            igroup: igroup,
                                                            week: 2,
                                                            weekday: index + 1),
                                                      ],
                                                    );
                                                  },
                                                )),
                                            ExpansionPanel(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                isExpanded:
                                                    controller.week2.value,
                                                canTapOnHeader: true,
                                                headerBuilder:
                                                    (context, isExpand) {
                                                  return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: CustomText(
                                                        "II неделя",
                                                        fontWeight: true,
                                                      ));
                                                },
                                                body: AlignedGridView.count(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  crossAxisSpacing: 8,
                                                  mainAxisSpacing: 4,
                                                  crossAxisCount:
                                                      context.isLandscape
                                                          ? 2
                                                          : 1,
                                                  itemCount: weekend.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        CustomText(
                                                            weekend[index]),
                                                        listWidget(
                                                            ifacult: ifacult,
                                                            igroup: igroup,
                                                            week: 1,
                                                            weekday: index + 1),
                                                      ],
                                                    );
                                                  },
                                                ))
                                          ])),
                                ],
                              )))));
                default:
                  return SizedBox();
              }
            }),
      ),
    );
  }
}

class cardWidget extends StatelessWidget {
  final e;
  const cardWidget({required this.e, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      leading:
          "${(e.time.start).replaceRange(5, 8, '').toString()}\n${e.time.end.replaceRange(5, 8, '').toString()}",
      title: e.subject,
      mintitle: e.type,
      subtitle: Flexible(
        fit: FlexFit.loose,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: 20,
                child: Text(
                    "${e.date.start.toString()} - ${e.date.end.toString()}",
                    style: TextStyle(color: colorText))),
            SizedBox(
              height: 20,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: e.audiences.length,
                  itemBuilder: (context, index1) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(
                        e.audiences[index1].name,
                        style: TextStyle(color: colorText),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 20,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: e.teachers.length,
                  itemBuilder: (context, index1) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(e.teachers[index1].name,
                          style: TextStyle(color: colorText)),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class listWidget extends StatelessWidget {
  final int ifacult;
  final int igroup;
  final int week;
  final int weekday;
  const listWidget(
      {required this.ifacult,
      required this.igroup,
      required this.week,
      required this.weekday,
      super.key});

  @override
  Widget build(BuildContext context) {
    List listlessons(int week, int weekday) {
      int max = getResISUCT.faculties[ifacult].groups[igroup].lessons.length;
      List list1 = [];
      for (int i = 0; i < max; i++) {
        if (getResISUCT
                    .faculties[ifacult].groups[igroup].lessons[i].date.week ==
                week &&
            getResISUCT.faculties[ifacult].groups[igroup].lessons[i].date
                    .weekday ==
                weekday) {
          list1.add(getResISUCT.faculties[ifacult].groups[igroup].lessons[i]);
        }
      }
      return list1;
    }

    return ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: listlessons(week, weekday).isNotEmpty
            ? listlessons(week, weekday).map((e) {
                return cardWidget(e: e);
              }).toList()
            : [
                const CustomCard(
                  title: "Нет пар",
                )
              ]);
  }
}

List<Lesson> listlessonsCustom(int week, int weekday) {
  int max = getResISUCT.faculties[ifacult].groups[igroup].lessons.length;
  List<Lesson> list1 = [];
  for (int i = 0; i < max; i++) {
    if (getResISUCT.faculties[ifacult].groups[igroup].lessons[i].date.week ==
            week &&
        getResISUCT.faculties[ifacult].groups[igroup].lessons[i].date.weekday ==
            weekday) {
      list1.add(getResISUCT.faculties[ifacult].groups[igroup].lessons[i]);
    }
  }

  return list1;
}

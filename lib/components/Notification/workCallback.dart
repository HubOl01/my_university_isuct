import 'dart:io';
import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../Pages/schedule/lessonsPage.dart';
import '../../api/ru_isuct.dart';
import '../../custom/customArg.dart';
import '../../main.dart';
import '../weekNumber.dart';

@pragma('vm:entry-point')
Future callbackDispatcher() async {
  if (Platform.isAndroid) PathProviderAndroid.registerWith();
  DartPluginRegistrant.ensureInitialized();
  Workmanager().executeTask((task, inputData) async {
    var app = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(app.path);
    var box = await Hive.openBox('my_university');
    igroup = box.get('authGroup') ?? 0;
    ifacult = box.get('authFacult') ?? 0;
    await offlineApi();
    listScheduleToday1 = (!isEmptyData)
        ? (DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day)
                    .weekday ==
                DateTime.monday)
            ? listlessonsCustom(
                weekNumber(DateTime(DateTime.now().year, DateTime.now().month,
                                DateTime.now().day)) %
                            2 ==
                        0
                    ? 1
                    : 2,
                1,
              )
            : (DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                        .weekday ==
                    DateTime.tuesday)
                ? listlessonsCustom(
                    weekNumber(DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day)) %
                                2 ==
                            0
                        ? 1
                        : 2,
                    2,
                  )
                : (DateTime(DateTime.now().year, DateTime.now().month,
                                DateTime.now().day)
                            .weekday ==
                        DateTime.wednesday)
                    ? listlessonsCustom(
                        weekNumber(DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day)) %
                                    2 ==
                                0
                            ? 1
                            : 2,
                        3,
                      )
                    : (DateTime(DateTime.now().year, DateTime.now().month,
                                    DateTime.now().day)
                                .weekday ==
                            DateTime.thursday)
                        ? listlessonsCustom(
                            weekNumber(DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)) %
                                        2 ==
                                    0
                                ? 1
                                : 2,
                            4,
                          )
                        : (DateTime(DateTime.now().year, DateTime.now().month,
                                        DateTime.now().day)
                                    .weekday ==
                                DateTime.friday)
                            ? listlessonsCustom(
                                weekNumber(DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day)) %
                                            2 ==
                                        0
                                    ? 1
                                    : 2,
                                5,
                              )
                            : (DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)
                                        .weekday ==
                                    DateTime.saturday)
                                ? listlessonsCustom(
                                    weekNumber(DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day)) %
                                                2 ==
                                            0
                                        ? 1
                                        : 2,
                                    6,
                                  )
                                : []
        : [];
    print(
        "День сегодня333: ${listScheduleToday1.length} and subject333 ${listScheduleToday1.first.subject.toString()}");
    if (task == "schedule") {
      print("task123 : ${task} ");
      // LocalNotificationService service =  LocalNotificationService();

      service.multipleNotificationShowToday(
        listScheduleToday1.length,
        listScheduleToday1,
      );
    }
    return Future.value(true);
  });
}

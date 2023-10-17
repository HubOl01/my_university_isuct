import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../../model/isuctModel.dart';

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> intialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationService.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
 print('payload $details');
      onNotificationClick.add(details.payload);
      },
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'description',
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showScheduledNotification(
      {required int id,
      required String title,
      required String body,
      required int seconds}) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: seconds)),
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showNotificationWithPayload(
      {required int id,
      required String title,
      required String body,
      required String payload}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details,
        payload: payload);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

Future<void> multipleNotificationShowToday(
      int length,
      List<Lesson>
          listSchedule /* List<String> subjects,
      List<String> time, List<String> teachers, List<String> audiences */
      ) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('Channel_id', 'Уведомление для каждой пары',
            priority: Priority.high,
            importance: Importance.max,
            ongoing: false,
            autoCancel: true,
            fullScreenIntent: true,
            setAsGroupSummary: true,
            icon: "@mipmap/ic_launcher",
            groupKey: 'commonSchedule');

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    List<String> subjects = [];
    for (int i = 0; i < length; i++) {
      Future.delayed(Duration(milliseconds: 500), (){
        _localNotificationService.show(
            i,
            listSchedule[i].subject,
            '${listSchedule[i].time!.start!.replaceRange(5, 8, '').toString()}-${listSchedule[i].time!.end!.replaceRange(5, 8, '').toString()} ${listSchedule[i].type} ${listSchedule[i].teachers!.first.name}\n${listSchedule[i].audiences!.first.name}',
            notificationDetails, payload: 'payload navigation');
      });
      subjects.add('${listSchedule[i].audiences!.first.name.toString()} ${listSchedule[i].type.toString()} ${listSchedule[i].subject.toString()}');
    }
    String par = "пара";
    if (length < 5 ){
      par = "пары";
    }else if(length == 1){
      par = "пара";
    }else{
      par = "пар";
    }
    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        subjects,
        contentTitle: !listSchedule.first.type!.contains("—") ? 'Сегодня ${length} $par' : "Сегодня",
        summaryText: 'Расписание на сегодня');

    AndroidNotificationDetails androidNotificationSpesific =
        AndroidNotificationDetails('groupChennelId', 'Уведомление пар',
            styleInformation: inboxStyleInformation,
            
            groupKey: 'commonSchedule',
            icon: "@mipmap/ic_launcher",
            ongoing: true,
            priority: Priority.high,
            importance: Importance.max,
            autoCancel: true,
            fullScreenIntent: true,
            setAsGroupSummary: true);
    NotificationDetails platformChannelSpe =
        NotificationDetails(android: androidNotificationSpesific);
    await _localNotificationService.show(
        length+1, 'Сегодня', !listSchedule.first.type!.contains("—") ? '${length} $par' : '', platformChannelSpe, payload: 'payload navigation');
  }

// Future<void> multipleNotificationShowToday(
//   int length,
//   List<Lesson> listSchedule,
// ) async {
//   for (int i = 0; i < length; i++) {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('Channel_id_$i', 'Channel_title_$i',
//         groupKey: 'commonSchedule',
//             priority: Priority.high,
//             importance: Importance.max,
//             ongoing: true,
//             autoCancel: true,
//             fullScreenIntent: true,
//             icon: "@mipmap/ic_launcher");

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     await Future.delayed(Duration(milliseconds: 1500 * i), () {
//       _localNotificationService.show(
//           i,
//           listSchedule[i].subject,
//           '${listSchedule[i].time!.start!.replaceRange(5, 8, '').toString()}-${listSchedule[i].time!.end!.replaceRange(5, 8, '').toString()} ${listSchedule[i].type} ${listSchedule[i].teachers!.first.name}\n${listSchedule[i].audiences!.first.name}',
//           notificationDetails,
//           payload: 'payload navigation');
//     });
//   }

//   List<String> subjects = listSchedule.map((lesson) =>
//       '${lesson.audiences!.first.name.toString()} ${lesson.type.toString()} ${lesson.subject.toString()}').toList();

//   InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
//     subjects,
//     contentTitle: 'Сегодня ${length} пар',
//     summaryText: 'Расписание на сегодня',
//   );

//   AndroidNotificationDetails androidNotificationSpesific =
//       AndroidNotificationDetails('groupChennelId', 'groupChennelTitle',
//           styleInformation: inboxStyleInformation,
//           groupKey: 'commonSchedule',
//           icon: "@mipmap/ic_launcher",
//           ongoing: true,
//           priority: Priority.high,
//           importance: Importance.max,
//           autoCancel: true,
//           fullScreenIntent: true,
//           setAsGroupSummary: true);

//   NotificationDetails platformChannelSpe =
//       NotificationDetails(android: androidNotificationSpesific);

//   await _localNotificationService.show(
//       length + 1, 'Сегодня', '${length} пар', platformChannelSpe,
//       payload: 'payload navigation');
// }

  /* Future<void> multipleNotificationShowTomorrow(
      int length,
      List<Lesson>
          listSchedule
      ) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('Channel_id', 'Channel_title',
            priority: Priority.high,
            importance: Importance.max,
            ongoing: true,
            autoCancel: false,
            icon: "@mipmap/ic_launcher",
            groupKey: 'commonSchedule');

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    List<String> subjects = [];
    for (int i = 0; i < length; i++) {
      Future.delayed(Duration(milliseconds: 500), () {
        _localNotificationService.show(
            i,
            listSchedule[i].subject,
            '${listSchedule[i].time!.start!.replaceRange(5, 8, '').toString()}-${listSchedule[i].time!.end!.replaceRange(5, 8, '').toString()} ${listSchedule[i].teachers!.first.name}\n${listSchedule[i].audiences!.first.name}',
            notificationDetails, payload: 'payload navigation');
      });
      subjects.add('${listSchedule[i].audiences!.first.name.toString()} ${listSchedule[i].subject.toString()}');
    }
    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        subjects,
        contentTitle: 'Завтра ${length} пар',
        summaryText: 'Расписание на завтра');

    AndroidNotificationDetails androidNotificationSpesific =
        AndroidNotificationDetails('groupChennelId', 'groupChennelTitle',
            styleInformation: inboxStyleInformation,
            groupKey: 'commonSchedule',
            icon: "@mipmap/ic_launcher",
            ongoing: true,
            
            priority: Priority.high,
            importance: Importance.max,
            autoCancel: false,
            fullScreenIntent: true,
            setAsGroupSummary: true);
    NotificationDetails platformChannelSpe =
        NotificationDetails(android: androidNotificationSpesific);
    await _localNotificationService.show(
        length+1, 'Завтра', '${length} пар', platformChannelSpe, payload: 'payload navigation');
  } */
  // void onDidReceiveNotificationResponse() {
  //   print('payload $payload');
  //   if (payload != null && payload.isNotEmpty) {
  //     onNotificationClick.add(payload);
  //   }
  // }
}
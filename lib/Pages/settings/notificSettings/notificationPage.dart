import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';

import '../../../Storage/storage.dart';
import '../../../components/Notification/LocalNotificationService.dart';
import '../../../components/Notification/workCallback.dart';
import '../../../custom/customArg.dart';
import '../../../main.dart';
import '../../../styles/colors.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var test = false;
  @override
  void initState() {
    super.initState();
    initAutoStart();
  }

  Future<void> initAutoStart() async {
    try {
      test = await (isAutoStartAvailable as FutureOr<bool>);
      print(test);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Уведомления"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 10,
            ),
            SwitchListTile(
              title: Text("Уведомление каждый день в 7:30"),
              value: isSchedule,
              activeColor: colorBlue,
              onChanged: (value) async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.reminders,
                  Permission.ignoreBatteryOptimizations,
                ].request();
                print(
                    "Permission handler: ${statuses} Permission.notification ${Permission.notification.status}");
                if (await Permission.notification.isDenied) {
                  showDialog(
                      context: context,
                      builder: (builder) => AlertDialog(
                            title: Text("Ошибка"),
                            content: Text(
                                "Включите уведомление в настройках приложения в устройстве"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    setState(() => isSchedule = false);
                                    Get.back();
                                  },
                                  child: Text("Ок"))
                            ],
                          ));
                } else {
                  if (await Permission.reminders.isGranted &&
                      await Permission.ignoreBatteryOptimizations.isGranted) {
                    setState(() => isSchedule = value);
                    switchSchedule(isSchedule);
                    AppMetrica.reportEvent('Уведомления (настройки)');
                    service = LocalNotificationService();
                    service.intialize();
                    listenToNotification();

                    Workmanager()
                        .initialize(callbackDispatcher, isInDebugMode: false);
                    if (!isSchedule) {
                      await FlutterLocalNotificationsPlugin().cancelAll();
                      Workmanager().cancelAll();
                    } else {
                      Workmanager().cancelByUniqueName("1");
                      final now = DateTime.now();
                      final targetTime =
                          DateTime(now.year, now.month, now.day, 7, 30);
                      final initialDelay = targetTime.difference(now);
                      Workmanager().registerPeriodicTask("1", "schedule",
                          frequency: Duration(days: 1),
                          initialDelay: initialDelay);
                    }
                  } else {
                    setState(() => isSchedule = false);
                  }
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            test
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                        color: Theme.of(context).primaryColor,
                        elevation: 5,
                        
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                      "Включите автозапуск для корректной работы с уведомлением"),
                                ),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                        onPressed: () async {
                                          await getAutoStartPermission();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            "Включить",
                                            style: TextStyle(color: colorBlue),
                                          ),
                                        )))
                              ]),
                        ),
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                    child: Text("Настройка вручную (если не работает)"),
                    onPressed: () async => AppSettings.openAppSettings()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 50,
                  child: TextButton(
                      onPressed: () {
                        launchUrl(
                          Uri.parse(
                              "https://telegra.ph/Kak-vklyuchit-uvedomlenie-10-01"),
                        );
                      },
                      child: Text(
                        "Как вручную настроить?",
                        style: TextStyle(color: colorBlue),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}

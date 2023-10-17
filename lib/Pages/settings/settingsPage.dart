import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_university_isuct/Pages/AuthPage/authPage.dart';
import 'package:my_university_isuct/Pages/settings/notificSettings/notificationPage.dart';
import 'package:my_university_isuct/styles/colors.dart';
import '../../Storage/storage.dart';
import 'About/aboutPage.dart';
import 'Helper/HelperPage.dart';
import 'Themes/themePage.dart';
import 'techSupport/techSupportPage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: SizedBox(
        height: context.isLandscape
            ? context.isTablet
                ? context.height - 90
                : context.height
            : context.height - 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: context.height / 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Настройки",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    )),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.photo_outlined),
                title: Text("Режим темы"),
                onTap: () {
                  AppMetrica.reportEvent('Режим темы (настройки)');
                  Get.to(ThemePage());
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Row(
                children: [
                  Text("Уведомления"),
                  SizedBox(
                    width: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: colorBlue.withOpacity(0.14),
                        child: Text("beta",
                            style: TextStyle(color: colorBlue, fontSize: 14))),
                  ),
                ],
              ),
              onTap: () {
                Get.to(NotificationPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("Помощь"),
              onTap: () {
                AppMetrica.reportEvent('Помощь (настройки)');
                Get.to(HelperPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.support_agent),
              title: Text("Обратиться в техподдержку"),
              onTap: () {
                AppMetrica.reportEvent('Обратиться в техподдержку (настройки)');
                Get.to(TechSupportPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("О приложении"),
              onTap: () {
                AppMetrica.reportEvent('О приложении (настройки)');
                Get.to(AboutPage());
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 45,
                child: ElevatedButton(
                    onPressed: () {
                      authStartPut("", 0, 0, false);
                      AppMetrica.reportEvent('Сменить курс/группу (настройки)');
                      Get.offAll(AuthPage());
                    },
                    child: Text("Сменить курс/группу")),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

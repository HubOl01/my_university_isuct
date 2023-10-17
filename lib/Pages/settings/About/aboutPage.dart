import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:my_university_isuct/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../components/updateApp.dart';
import 'aboutController.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customTextStyle = TextStyle(
        fontSize: 30, fontWeight: FontWeight.bold, color: Theme.of(context).primaryTextTheme.titleMedium!.color);
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).primaryTextTheme.titleMedium!.color,
            elevation: 0,
          ),
          body: controller.isloading.value
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: context.width,
                          height: context.height / 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  color: colorBlue,
                                  child: Image.asset(
                                    "assets/logo/icon-foreground.png",
                                    height: 100,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              SizedBox(height: 20,),
                              Text(
                                controller.appName.value,
                                style: customTextStyle,
                              ),
                              Text(
                                "Версия:  ${controller.version.value}",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          )),
                      ListTile(
                          title: Text("Подпишитесь на наше сообщество, чтобы не пропустить последние новости"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  launchUrl(
                                    Uri.parse("https://vk.com/my_university_isuct"),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                icon: Logo(
                                  Logos.vk,
                                ),
                              ),
                              SizedBox(width: 10,),
                              IconButton(
                                onPressed: () {
                                  launchUrl(
                                    Uri.parse("https://t.me/my_university_isuct"),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                icon: Logo(
                                  Logos.telegram,
                                ),
                              ),
                            ],
                          )),
                      // Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: context.width,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                AppMetrica.reportEvent('Информация о приложении (обновление)');
                                updateApp();
                              },
                              child: Text(
                                  "Проверить наличие обновлений")),
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}

final AboutController controller = Get.put(AboutController());

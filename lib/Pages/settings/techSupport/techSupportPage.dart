import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class TechSupportPage extends StatelessWidget {
  const TechSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Техподдержка"),
      ),
      body: ListView(
          padding: EdgeInsets.all(0),
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "Вы можете обратиться в техподдержку через сообщества VK или Telegram",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              )),
            ),
            ListTile(
              title: Text("Написать лично"),
              trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  launchUrl(
                                    Uri.parse("https://vk.com/im?media=&sel=-222644255"),
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
                                    Uri.parse("https://t.me/foward01"),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                icon: Logo(
                                  Logos.telegram,
                                ),
                              ),
                            ],
                          ),
            ),
            ListTile(
              title: Text("Написать в обсуждениях"),
              trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  launchUrl(
                                    Uri.parse("https://vk.com/board222644255"),
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
                                    Uri.parse("https://t.me/my_university_isuct_discussions"),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                icon: Logo(
                                  Logos.telegram,
                                ),
                              ),
                            ],
                          ),
            ),
          ]),
    );
  }
}

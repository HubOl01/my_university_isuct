import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_university_isuct/Pages/settings/Helper/data/helpList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Model/help.dart';

class HelperPage extends StatelessWidget {
  const HelperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Помощь"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25,),
            SizedBox(
              width: context.width,
              height: 50,
              child: ElevatedButton(onPressed: (){
                launchUrl(Uri.parse("https://telegra.ph/Rukovodstvo-polzovatelya-prilozheniya-Moj-univer---IGHTU-09-25"), mode: LaunchMode.inAppWebView);
              }, child: Text("Руководство пользователя"), style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states){
                return Theme.of(context).primaryColor;
              }),foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states){
                return Theme.of(context).primaryTextTheme.titleMedium!.color;
              })
              ),
              ),
            ),
            SizedBox(height: 25,),
            ExpansionPanelList.radio(
              children:
                  questionsRU.map<ExpansionPanelRadio>((HelpModel helpModel) {
                return ExpansionPanelRadio(
                  canTapOnHeader: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(helpModel.question),
                      );
                    },
                    body: ListTile(
                      title: Text(helpModel.answer),
                    ),
                    value: helpModel.question);
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                
                    text: TextSpan(children: [
                  new TextSpan(
                    text:
                        "Не нашли вопрос? Вы можете написать любые вопросы через сообщества ",
                    style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color),
                  ),
                  new TextSpan(
                    text: "VK",
                    style: new TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(
                          Uri.parse("https://vk.com/topic-222644255_49439598"),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                  ),new TextSpan(
                    text: " или ",
                    style: new TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color),
                  ),new TextSpan(
                    text: "Telegram",
                    style: new TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(
                          Uri.parse("https://t.me/my_university_isuct_discussions/7"),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
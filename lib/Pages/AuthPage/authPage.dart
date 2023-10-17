import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_university_isuct/api/ru_isuct.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Storage/storage.dart';
import '../../custom/customArg.dart';
import '../../main.dart';
import '../../styles/colors.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

bool isGroup = false;

class _AuthPageState extends State<AuthPage> {
  TextEditingController groupController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupController.text = courseAndGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: getISUCT(),
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: context.height / 2,
                      child: Center(
                        child: ClipRRect(
                          child: Container(
                            height: 125,
                            width: 125,
                            color: colorBlue,
                            child: Image.asset(
                              "assets/logo/icon-foreground.png",
                              height: 125,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Text(
                      "Добро пожаловать!\nВведите свой курс и группу (пример: 2-25)",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: groupController,
                        cursorColor: colorBlue,
                        decoration: InputDecoration(
                            label: Text("Курс-Группа (2-25)"),                          
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                            floatingLabelStyle:
                            
                              TextStyle(color: Colors.blueAccent.shade400, fontWeight: FontWeight.w500),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey.shade600)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorBlue, width: 1.5),
                            ))),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (groupController.text.trim().isNotEmpty) {
                                setState(() {
                                  if (groupController.text.trim().contains("/"))
                                    groupController.text = groupController.text
                                        .trim()
                                        .replaceAll("/", "-");
                                  courseAndGroup = groupController.text.trim();
                                  ifacult = indexListFacult(
                                      groupController.text.trim());
                                  igroup = indexListGroup(
                                      groupController.text.trim());
                                });
                                if (groupController.text.trim().contains("-") &&
                                    isGroup &&
                                    groupController.text.trim().length >= 3 &&
                                    groupController.text
                                            .trim()
                                            .capitalizeFirst !=
                                        '-') {
                                  setState(() {
                                    isStart = true;
                                  });
                                  authStartPut(
                                      courseAndGroup, ifacult, igroup, isStart);
                                  AppMetrica.reportEvent(
                                      'Группа: ${courseAndGroup}');
                                  Get.offAll(MyHomePage());
                                } else
                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Ошибка"),
                                            content: Text(
                                                "Похоже вы неправильно ввели курс-группу или нет такой группы"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text("ОК"))
                                            ],
                                          ));
                              }
                            },
                            child: !isLoading
                                ? Text("Войти")
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ))),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            launchUrl(
                                Uri.parse(
                                    "https://telegra.ph/Rukovodstvo-polzovatelya-prilozheniya-Moj-univer---IGHTU-09-25"),
                                mode: LaunchMode.inAppWebView);
                          },
                          child: Text(
                            "Инструкция",
                            style: TextStyle(color: colorBlue),
                          ),
                        ))
                  ],
                );
              }),
        ),
      ),
    );
  }
}

bool isLoading = false;
int indexListGroup(var name) {
  isLoading = true;
  isGroup = false;
  print("indexListGroup {${getResISUCT.faculties.length}}");
  for (int i = 0; i < getResISUCT.faculties.length; i++) {
    for (int j = 0; j < getResISUCT.faculties[i].groups.length; j++) {
      if (getResISUCT.faculties[i].groups[j].name == name) {
        isLoading = false;
        isGroup = true;
        return j;
      }
    }
  }
  isGroup = false;
  isLoading = false;
  return 0;
}

int indexListFacult(var name) {
  isLoading = true;
  isGroup = false;
  print("indexListFacult {${getResISUCT.faculties.length}}");
  for (int i = 0; i < getResISUCT.faculties.length; i++) {
    for (int j = 0; j < getResISUCT.faculties[i].groups.length; j++) {
      if (getResISUCT.faculties[i].groups[j].name == name) {
        isGroup = true;
        isLoading = false;
        return i;
      }
    }
  }
  isGroup = false;
  isLoading = false;
  return 0;
}

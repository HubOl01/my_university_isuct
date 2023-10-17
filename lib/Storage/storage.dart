import 'package:hive/hive.dart';

import '../main.dart';

Future switCH(int index) async {
  var box = await Hive.openBox('my_university');
  box.put("themeMode", index);
  getMode();
  await box.compact();
  await box.close();
}

Future authMoodlePut(
    String login, String pass, bool checkedLogin, bool checkedAutoSign) async {
  var box = await Hive.openBox('my_university');
  box.put("authMoodleLogin", login);
  box.put("authMoodlePassword", pass);
  box.put("authMoodleCheckedLogin", checkedLogin);
  box.put("authMoodleCheckedAutoSign", checkedAutoSign);
  print(
      "box < authMoodlePut > : authMoodleLogin=${box.get("authMoodleLogin")}, authMoodleCheckedLogin=${box.get("authMoodleCheckedLogin")}, authMoodleCheckedAutoSign=${box.get("authMoodleCheckedAutoSign")},");
  await box.compact();
  await box.close();
}

Future authStartPut(
    String facultAndGroup, int facult, int group, bool isStart) async {
  var box = await Hive.openBox('my_university');
  box.put("authCourseAndGroup", facultAndGroup);
  box.put("authFacult", facult);
  box.put("authGroup", group);
  box.put("authIsStart", isStart);
  print(
      "box < authStartPut > : authIsStart=${box.get("authIsStart")}, authFacult=${box.get("authFacult")}, authGroup=${box.get("authGroup")},");
  await box.compact();
  await box.close();
}

Future switchSchedule(bool isSchedule) async {
  var box = await Hive.openBox('my_university');
  box.put("isSchedule", isSchedule);
  await box.compact();
  await box.close();
}

Future versionCurrent(String version) async {
  var box = await Hive.openBox('my_university');
  box.put("versionApp", version);
  await box.compact();
  await box.close();
}
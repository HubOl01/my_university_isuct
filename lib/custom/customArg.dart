import '../model/isuctModel.dart';

class ListSchedule {
  final length = 0;
  final List<String> subject = [];
  final List<String> time = [];
  final List<String> teachers = [];
  final List<String> audiences = [];
}

List<Lesson> listScheduleToday = [];
List<Lesson> listScheduleToday1 = [];
String urlWebview = 'https://edu.isuct.ru/login/index.php';
// List<Lesson> listScheduleTomorrow = [];

  bool checkedLogin = false;
  bool checkedAutoSign = false;
  String user = "";
  String pass = "";

String courseAndGroup = '';
int ifacult = 0;
int igroup = 0;
bool isStart = false;

bool isSchedule = false;

String versionCurrent = '1.0.0';
// int 
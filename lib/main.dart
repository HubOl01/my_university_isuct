import 'dart:async';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:my_university_isuct/Pages/AuthPage/MyAuth.dart';
import 'package:my_university_isuct/Storage/storage.dart';
import 'package:my_university_isuct/styles/custom_icons_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:my_university_isuct/Pages/moodle/moodle.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:workmanager/workmanager.dart';
import 'Pages/calendar/calendarPage.dart';
import 'Pages/notes/notesPage.dart';
import 'Pages/schedule/lessonsPage.dart';
import 'Pages/settings/Themes/Themes.dart';
import 'Pages/settings/settingsPage.dart';
import 'api/ru_isuct.dart';
import 'components/Notification/LocalNotificationService.dart';
import 'components/Notification/workCallback.dart';
import 'components/updateApp.dart';
import 'custom/customArg.dart';
import 'styles/colors.dart';

Future checkedPeremissions(bool isSchedule) async {
  if (await Permission.notification.isDenied) {
    isSchedule = false;
    switchSchedule(isSchedule);
    print("Notific offdddd");
  } else {
    if (await Permission.reminders.isDenied &&
        await Permission.ignoreBatteryOptimizations.isDenied) {
      isSchedule = false;
      switchSchedule(isSchedule);
      print("Notific offdddd");
    }
  }
}

Future<void> initAutoStart() async {}

var db;
int? indexMode;
Future getMode() async {
  var app = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(app.path);
  var box = await Hive.openBox('my_university');
  indexMode = box.get('themeMode') ?? 0;
  print("Mode = ${indexMode!}");
}

LocalNotificationService service = LocalNotificationService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();
  };
  await dotenv.load(fileName: ".env");

  try {
    AppMetrica.activate(
        AppMetricaConfig("${dotenv.env['AppMetrica']}", logs: true));
  } catch (ex) {
    print("app_metrica: ${ex}");
  }
  updateApp();
  AppMetrica.reportEvent('Приложение открыто');
  var app = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(app.path);
  var box = await Hive.openBox('my_university');
  indexMode = box.get('themeMode') ?? 0;
  isStart = box.get('authIsStart') ?? false;
  courseAndGroup = box.get("authCourseAndGroup") ?? '';
  isSchedule = box.get("isSchedule") ?? false;
  igroup = box.get('authGroup') ?? 0;
  ifacult = box.get('authFacult') ?? 0;
  user = box.get("authMoodleLogin") ?? '';
  pass = box.get("authMoodlePassword") ?? '';
  checkedLogin = box.get("authMoodleCheckedLogin") ?? false;
  checkedAutoSign = box.get("authMoodleCheckedAutoSign") ?? false;

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await checkedPeremissions(isSchedule);
  service = LocalNotificationService();
  service.intialize();
  listenToNotification();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  await Permission.storage.request();

  runApp(isStart ? MyApp() : MyAuth());
}

void listenToNotification() {
  service.onNotificationClick.stream.listen(onNoticationListener);
}

void onNoticationListener(String? payload) {
  if (payload != null && payload.isNotEmpty) {
    print('payload $payload');
    final MyHomePageController controller = Get.put(MyHomePageController());
    controller.changeTabIndex(0);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, child) => GetMaterialApp(
            themeMode: Provider.of<ThemeProvider>(context).themeMode,
            theme: Themes.light,
            darkTheme: Themes.dark,
            locale: Locale('ru', 'RU'),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('ru', 'RU'),
            ],
            debugShowCheckedModeBanner: false,
            home: MyHomePage()));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.localToGlobal(details.globalPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyHomePageController>(
        init: MyHomePageController(),
        initState: (controller) {},
        builder: (controller) {
          return Scaffold(
              body: IndexedStack(
                index: controller.tabIndex.value,
                children: pages,
              ),
              bottomNavigationBar: Obx(() => BottomNavigationBar(
                    onTap: controller.changeTabIndex,
                    currentIndex: controller.tabIndex.value,
                    iconSize: 30,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    unselectedFontSize: 9,
                    selectedFontSize: 9,
                    enableFeedback: true,
                    landscapeLayout:
                        BottomNavigationBarLandscapeLayout.centered,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.calendar_month), label: "Календарь"),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.schedule), label: "Расписание пар"),
                      BottomNavigationBarItem(
                          icon: GestureDetector(
                              onTap: () {
                                if (controller.tabIndex.value == 2) {
                                  webView
                                    ..evaluateJavascript(
                                        source:
                                            "window.scrollTo({top: 0, behavior: 'smooth'});");
                                }
                                controller.changeTabIndex(2);
                              },
                              onDoubleTap: () {
                                if (controller.tabIndex.value == 2)
                                  webView.loadUrl(
                                      urlRequest: URLRequest(
                                          url: Uri.parse(
                                              'https://edu.isuct.ru')));
                              },
                              onLongPress: () {
                                if (controller.tabIndex.value == 2)
                                  _showContextMenu(context);
                              },
                              onTapDown: (details) => _getTapPosition(details),
                              child: Icon(
                                CustomIcons.moodle,
                              )),
                          label: "Moodle"),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.notes), label: "Заметки"),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.settings), label: "Настройки"),
                    ],
                  )));
        });
  }

  void _showContextMenu(BuildContext context) async {
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
            MediaQuery.of(context).size.width / 2 - 100, // левый край
            MediaQuery.of(context).size.height - 270, // верхний край
            MediaQuery.of(context).size.width / 2 + 100, // правый край
            0 /* MediaQuery.of(context).size.height / 2 - 2000 */ // нижний край (высота экрана)
            ),
        items: [
          const PopupMenuItem(
            value: 'share',
            child: Text('Поделиться'),
          ),
          const PopupMenuItem(
            value: 'search',
            child: Text('Поиск'),
          ),
          const PopupMenuItem(
            value: 'moodle',
            child: Text('Вернуться в moodle'),
          ),
          const PopupMenuItem(
              value: 'exitToEdu',
              child: Text(
                "Выйти из moodle",
                style: TextStyle(color: Colors.red),
              )),
        ]);
    switch (result) {
      case 'share':
        Share.share(urlWebview);
        break;
      case 'search':
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Wrap(children: [
                  Container(
                    color: context.theme.scaffoldBackgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                        autofocus: true,
                        controller: searchController,
                        cursorColor: colorBlue,
                        decoration: InputDecoration(
                          label: Text("Поиск"),
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.grey.shade600)),
                          floatingLabelStyle: TextStyle(
                              color: Colors.blueAccent.shade400,
                              fontWeight: FontWeight.w500),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colorBlue, width: 1.5),
                          ),
                          suffixIconColor: colorBlue,
                          suffixIcon: IconButton(
                              splashRadius: 20,
                              icon: Icon(Icons.search),
                              onPressed: () {
                                if (searchController.text.trim().isNotEmpty)
                                  setState(() {
                                    if (searchController.text
                                            .trim()
                                            .contains("http://") ||
                                        searchController.text
                                            .trim()
                                            .contains("https://"))
                                      webView.loadUrl(
                                          urlRequest: URLRequest(
                                              url: Uri.parse(searchController
                                                  .text
                                                  .trim())));
                                    else if (searchController.text
                                            .trim()
                                            .contains(".com") ||
                                        searchController.text
                                            .trim()
                                            .contains(".ru"))
                                      webView.loadUrl(
                                          urlRequest: URLRequest(
                                              url: Uri.parse('https://' +
                                                  searchController.text
                                                      .trim())));
                                    else
                                      webView.loadUrl(
                                          urlRequest: URLRequest(
                                              url: Uri.parse(
                                                  'https://ya.ru/search/?text=' +
                                                      searchController.text
                                                          .trim())));
                                    searchController.clear();
                                  });
                              }),
                        )),
                  )
                ]),
              );
            });
        break;
      case 'exitToEdu':
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Подтверждение"),
                  content: Text("Вы хотите выйти из moodle?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Нет")),
                    TextButton(
                        onPressed: () {
                          authMoodlePut('', '', false, false);
                          setState(() {
                            user = '';
                            pass = '';
                            userMoodleController.clear();
                            passMoodleController.clear();
                            checkedLogin = false;
                            checkedAutoSign = false;
                          });
                          webView.loadUrl(
                              urlRequest: URLRequest(
                                  url: Uri.parse(
                                      "https://edu.isuct.ru/login/index.php")));
                          Get.back();
                        },
                        child: Text("Да"))
                  ],
                ));
        break;
      case 'moodle':
        webView.loadUrl(
            urlRequest: URLRequest(url: Uri.parse('https://edu.isuct.ru')));
        break;
    }
  }
}

List<Widget> pages = [
  CalendarPage(),
  LessonsPage(),
  MoodlePage(),
  NotesPage(),
  SettingsPage(),
];
List<String> pagesString = [
  "Календарь",
  "Расписание пар",
  "Moodle",
  "Заметки",
  "Настройки",
];

class MyHomePageController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    print(index);
    tabIndex.value = index;
    AppMetrica.reportEvent('Раздел ${pagesString[index]}');
    update();
  }
}

int indexListGroups(int ifacult, var name) {
  for (int i = 0; i < getResISUCT.faculties[ifacult].groups.length; i++) {
    if (getResISUCT.faculties[ifacult].groups[i].name == name) {
      return i;
    }
  }
  return 0;
}

int indexListFaculties(var name) {
  for (int i = 0; i < getResISUCT.faculties.length; i++) {
    if (getResISUCT.faculties[i].name == name) {
      return i;
    }
  }
  return 0;
}

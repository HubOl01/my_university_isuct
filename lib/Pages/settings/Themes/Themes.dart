import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';

import '../../../Storage/storage.dart';
import '../../../main.dart';
import '../../../styles/colors.dart';

class Themes {
  static final dark = ThemeData(
    brightness: Brightness.dark,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colorBlue),
    indicatorColor: colorBlue,
    sliderTheme: SliderThemeData(
        activeTrackColor: colorBlue,
        overlayColor: colorBlue.withOpacity(0.3),
        thumbColor: colorBlue,
        inactiveTrackColor: colorBlue.withOpacity(0.3)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ButtonStyle(backgroundColor: MaterialStatePropertyAll(colorBlue))),
    popupMenuTheme: PopupMenuThemeData(color: appBarColorDark),
    appBarTheme: AppBarTheme(
        backgroundColor: appBarColorDark,
        foregroundColor: textColorDark,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)))),
    scaffoldBackgroundColor: backgroundColorDark,
    expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: appBarColorDark,
        collapsedBackgroundColor: appBarColorDark),
    textTheme: TextTheme(
        bodyLarge: TextStyle(backgroundColor: textColorDark),
        bodySmall: TextStyle(backgroundColor: subColorDark)),
    backgroundColor: backgroundColorDark,
    dialogBackgroundColor: backgroundColorDark,
    primaryTextTheme:
        const TextTheme(titleMedium: TextStyle(color: Colors.white)),
    checkboxTheme: CheckboxThemeData(fillColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (!states.contains(MaterialState.selected)) {
        return Colors.transparent;
      }
      return colorBlue;
    })),
    primaryColor: appBarColorDark,
    snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.black87,
        actionTextColor: Colors.white,
        contentTextStyle: TextStyle(
          color: Colors.white,
        )),
    dividerColor: lineColorDark,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle: TextStyle(color: Colors.white),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: appBarColorDark,
        selectedIconTheme: IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: Colors.white.withOpacity(.5)),
        unselectedItemColor: Colors.white.withOpacity(.5),
        selectedItemColor: Colors.white),
    iconTheme: IconThemeData(color: textColorDark),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: textColorDark,
      backgroundColor: colorBlue,
    ),
    listTileTheme:
        ListTileThemeData(iconColor: textColorDark, textColor: textColorDark),
    switchTheme: SwitchThemeData(
      thumbColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue;
        }
        return Colors.white;
      }),
      trackColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.2)),
    ),
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
            color: textColorDark, fontSize: 25, fontWeight: FontWeight.bold)),
  );

  static final light = ThemeData(
    brightness: Brightness.light,
    sliderTheme: SliderThemeData(
        activeTrackColor: colorBlue,
        overlayColor: colorBlue.withOpacity(0.3),
        thumbColor: colorBlue,
        inactiveTrackColor: colorBlue.withOpacity(0.3)),
    expansionTileTheme: ExpansionTileThemeData(backgroundColor: colorWhite),
    primaryTextTheme:
        const TextTheme(titleMedium: TextStyle(color: Colors.black)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ButtonStyle(backgroundColor: MaterialStatePropertyAll(colorBlue))),
    inputDecorationTheme: InputDecorationTheme(),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colorBlue),
    indicatorColor: colorBlue,
    appBarTheme: AppBarTheme(
        backgroundColor: colorBlue,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)))),
    checkboxTheme: CheckboxThemeData(fillColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (!states.contains(MaterialState.selected)) {
        return Colors.transparent;
      }
      return colorBlue;
    })),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: textColorDark,
      backgroundColor: colorBlue,
    ),
    primaryColor: colorWhite,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // backgroundColor: colorFiolet,
        // unselectedIconTheme: IconThemeData(color: colorFiolet)
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black.withOpacity(.5),
        selectedItemColor: colorBlue,
        selectedLabelStyle: TextStyle(color: colorBlue),
        selectedIconTheme: IconThemeData(color: colorBlue)),
  );
}

ThemeMode mode(int isDarked) {
  var mode = ThemeMode.system;
  switch (isDarked) {
    case 1:
      mode = ThemeMode.light;
      break;
    case 2:
      mode = ThemeMode.dark;
      break;
    default:
      mode = ThemeMode.system;
      break;
  }
  return mode;
}

int reversMode(ThemeMode mode) {
  var index = 0;
  switch (mode) {
    case ThemeMode.light:
      index = 1;
      break;
    case ThemeMode.dark:
      index = 2;
      break;
    default:
      index = 0;
      break;
  }
  return index;
}

List<String> themesString = [
  'Авто (по умолчанию)',
  'Светлый режим',
  'Темный режим'
];

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = mode(indexMode ?? 0);
  ThemeMode get themeMode => _themeMode;

  void toggleTheme(themeMode) async {
    _themeMode = themeMode;
    int index = reversMode(_themeMode);
    switCH(index);
    AppMetrica.reportEvent('Выбор темы: ${themesString[index]}');
    notifyListeners();
  }
}

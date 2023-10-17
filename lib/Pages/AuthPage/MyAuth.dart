import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:my_university_isuct/Pages/AuthPage/authPage.dart';
import 'package:provider/provider.dart';

import '../settings/Themes/Themes.dart';

class MyAuth extends StatelessWidget {
  const MyAuth({super.key});

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
            home: AuthPage()));
  }
}

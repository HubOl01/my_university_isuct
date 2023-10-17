import 'dart:convert';
import 'dart:io';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Storage/storage.dart';
import '../../custom/customArg.dart';
import '../../styles/colors.dart';

bool isLoadingMoodle = false;
bool isStartMoodle = true;
bool isErrorMoodle = true;
TextEditingController userMoodleController = TextEditingController();
TextEditingController passMoodleController = TextEditingController();
TextEditingController searchController = TextEditingController();
late InAppWebViewController webView;

class MoodlePage extends StatefulWidget {
  const MoodlePage({super.key});

  @override
  State<MoodlePage> createState() => _MoodlePageState();
}

class _MoodlePageState extends State<MoodlePage> {
  CookieManager cookieManager = CookieManager.instance();
  final GlobalKey webViewKey = GlobalKey();
  bool checkedAutoSignMoodle = checkedAutoSign;
  bool checkedLoginMoodle = checkedLogin;
  late PullToRefreshController pullToRefreshController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        useOnDownloadStart: true,
        cacheEnabled: true,
        javaScriptEnabled: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        cacheMode: AndroidCacheMode.LOAD_DEFAULT,
        thirdPartyCookiesEnabled: true,
      ),
      ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true, sharedCookiesEnabled: true));
  double _progress = 0;
  var _isObscure = true;
  String cookiesString = '';
  Future<void> updateCookies(Uri url) async {
    List<Cookie> cookies = await cookieManager.getCookies(url: url);
    cookiesString = '';
    for (Cookie cookie in cookies) {
      cookiesString += '${cookie.name}=${cookie.value};';
    }
    print(cookiesString);
  }

  @override
  void initState() {
    super.initState();
    if (userMoodleController.text.isEmpty &&
        passMoodleController.text.isEmpty) {
      userMoodleController.text = user;
      passMoodleController.text = pass;
    }
    pullToRefreshController = PullToRefreshController(
      onRefresh: () => webView.reload(),
      options: PullToRefreshOptions(
          color: Colors.white, backgroundColor: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await webView.canGoBack();
        if (isLastPage) {
          webView.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: !checkedAutoSign && isErrorMoodle
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                            height: context.height / 2 - 100,
                            child: Center(
                                child: Text(
                              "Вход в moodle",
                              style: TextStyle(fontSize: 30),
                            ))),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isErrorMoodle &&
                                    !isStartMoodle &&
                                    (userMoodleController.text
                                            .trim()
                                            .isNotEmpty &&
                                        passMoodleController.text.isNotEmpty)
                                ? Text(
                                    "Неверный логин или пароль, повторите еще раз",
                                    style: TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  )
                                : SizedBox(),
                            isErrorMoodle &&
                                    (userMoodleController.text
                                            .trim()
                                            .isNotEmpty &&
                                        passMoodleController.text.isNotEmpty)
                                ? SizedBox(
                                    height: 10,
                                  )
                                : SizedBox(),
                            TextField(
                              cursorColor: colorBlue,
                              controller: userMoodleController,
                              // maxLines: 30,
                              decoration: InputDecoration(
                                label: Text("Логин"),
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.grey.shade600)),
                                floatingLabelStyle: TextStyle(
                                    color: Colors.blueAccent.shade400,
                                    fontWeight: FontWeight.w500),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: colorBlue, width: 1.5),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              cursorColor: colorBlue,
                                controller: passMoodleController,
                                obscureText: _isObscure,
                                decoration: InputDecoration(
                                  label: Text("Пароль"),
                                  // isCollapsed: true,
                                  contentPadding: EdgeInsets.all(8),
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade600)),
                                  floatingLabelStyle: TextStyle(
                                      color: Colors.blueAccent.shade400,
                                      fontWeight: FontWeight.w500),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorBlue, width: 1.5),
                                  ),
                                  suffixIconColor: colorBlue,
                                  suffixIcon: IconButton(
                                      splashRadius: 20,
                                      icon: Icon(_isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      }),
                                )),
                          ],
                        ),
                        CheckboxListTile(
                          title: Text("Запомнить логин"),
                          value: checkedLoginMoodle,
                          onChanged: (newValue) {
                            setState(() {
                              checkedLoginMoodle = newValue!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading,
                        ),
                        CheckboxListTile(
                          title: Text("Выполнить автоматический вход"),
                          value: checkedAutoSignMoodle,
                          onChanged: (newValue) {
                            setState(() {
                              checkedAutoSignMoodle = newValue!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (userMoodleController.text
                                          .trim()
                                          .isNotEmpty &&
                                      passMoodleController.text.isNotEmpty) {
                                    AppMetrica.reportEvent(
                                        'Вход в moodle (кнопка)');
                                    setState(() {
                                      user = userMoodleController.text.trim();
                                      pass = passMoodleController.text;
                                      isErrorMoodle = false;
                                      isStartMoodle = false;
                                      isLoadingMoodle = true;
                                    });
                                  }
                                },
                                child: Text("Войти")))
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(
                        url:
                            Uri.parse(!isErrorMoodle
                                ? 'https://edu.isuct.ru/login/index.php'
                                : 'https://edu.isuct.ru'),
                        headers: {
                          HttpHeaders.authorizationHeader: 'Basic ' +
                              base64Encode(utf8.encode('$user:$pass')),
                          HttpHeaders.connectionHeader: 'keep-alive',
                          HttpHeaders.cookieHeader: cookiesString,
                        },
                      ),
                      pullToRefreshController: pullToRefreshController,
                      initialOptions: options,
                      onWebViewCreated:
                          (InAppWebViewController controller) async {
                        setState(() {
                          webView = controller;
                        });
                        final currentUrl = await controller.getUrl();
                        print("URLLLLLLL : ${currentUrl!.host}");
                        if (currentUrl.host
                            .contains("edu.isuct.ru/login/index.php")) {
                          setState(() {
                            isLoadingMoodle = true;
                          });
                        }
                      },
                      onLoadError: (controller, url, code, message) {
                        print('Load Error: code $code and message $message');
                        if (url.toString().contains("stream.isuct") ||
                            url.toString().contains("bbb.isuct") ||
                            url.toString().contains("mp4") ||
                            url.toString().contains("bigbluebuttonbn")) {
                          launchUrl(Uri.parse(url.toString()));
                        }
                        controller.goBack();
                      },
                      onLoadHttpError:
                          (controller, url, statusCode, description) {
                        print(
                            'HTTP Error: statusCode $statusCode and description $description');
                      },
                      onLoadStart: (controller, url) async {
                        if (url.toString().contains("bbb.isuct") ||
                            url.toString().contains("mp4") ||
                            url.toString().contains("bigbluebuttonbn")) {
                          launchUrl(Uri.parse(url.toString()));
                        }
                        if (url
                            .toString()
                            .contains("https://edu.isuct.ru/login/index.php")) {
                          setState(() {
                            isLoadingMoodle = true;
                          });
                        } else
                          setState(() => isLoadingMoodle = false);
                      },
                      onLoadStop: (controller, url) async {
                        await controller.evaluateJavascript(
                            source:
                                "document.getElementsByTagName('footer')[0].style.display = 'none'");

                        print("webbbbbb: ${url.toString()}");
                        if (url != null) {
                          await updateCookies(url);
                        }
                        if (url
                            .toString()
                            .contains("https://edu.isuct.ru/login/index.php")) {
                          setState(() {
                            isLoadingMoodle = true;
                          });
                          controller
                            ..evaluateJavascript(
                                source:
                                    "document.getElementById('username').value = '${user}'");
                          controller
                            ..evaluateJavascript(
                                source:
                                    "document.getElementById('password').value = '${pass}'");
                          await Future.delayed(Duration(seconds: 1), () {});
                          final scriptf =
                              "document.getElementById('loginerrormessage') !== null";
                          final result = await controller.evaluateJavascript(
                              source: scriptf);
                          final hasId = result as bool;
                          setState(() {
                            isErrorMoodle = hasId;
                            checkedAutoSign = !hasId;
                            isLoadingMoodle = !hasId;
                          });

                          print("TRUE or false:::${result}:::: ${hasId}");
                          if (!isErrorMoodle) {
                            controller
                              ..evaluateJavascript(
                                  source: "document.forms[0].submit()");
                                  controller
                              ..evaluateJavascript(
                                  source: "document.forms[0].submit()");
                            AppMetrica.reportEvent('Вход в moodle (submit())');
                            if (checkedLoginMoodle && !checkedAutoSignMoodle)
                              authMoodlePut(user, '', checkedLoginMoodle,
                                  checkedAutoSignMoodle);
                            else if (checkedAutoSignMoodle ||
                                (!checkedLoginMoodle && checkedLoginMoodle))
                              authMoodlePut(
                                  user, pass, true, checkedAutoSignMoodle);
                            else
                              authMoodlePut('', '', false, false);
                          }
                          if(checkedAutoSign){
                            controller
                              ..evaluateJavascript(
                                  source: "document.forms[0].submit()");
                                  AppMetrica.reportEvent('Автовход в moodle (submit())');
                          }
                        } else
                          setState(() => isLoadingMoodle = false);

                        pullToRefreshController.endRefreshing();
                        setState(() {
                          urlWebview = url.toString();
                        });
                      },
                      onProgressChanged:
                          (InAppWebViewController controller, int progress) {
                        setState(() {
                          _progress = progress / 100;
                        });
                        pullToRefreshController.beginRefreshing();
                        if (webView
                            .toString()
                            .contains("https://edu.isuct.ru/login/index.php"))
                          setState(() => isLoadingMoodle = true);
                        else
                          setState(() => isLoadingMoodle = false);
                      },
                      onDownloadStartRequest: (controller, url) async {
                        print("onDownloadStart url ${url.url.toString()}");
                        await FlutterDownloader.enqueue(
                          url: url.url.toString(),
                          fileName: url.suggestedFilename,
                          savedDir: (await getExternalStorageDirectory())!.path,
                          saveInPublicStorage: true,
                          showNotification: true,
                          openFileFromNotification: true,
                          headers: {
                            HttpHeaders.authorizationHeader: 'Basic ' +
                                base64Encode(utf8.encode('$user:$pass')),
                            HttpHeaders.connectionHeader: 'keep-alive',
                            HttpHeaders.cookieHeader: cookiesString,
                          },
                        );
                        pullToRefreshController.endRefreshing();
                      },
                    ),
                    _progress < 1
                        ? Container(
                            child: LinearProgressIndicator(
                              value: _progress,
                            ),
                          )
                        : SizedBox(),
                    isLoadingMoodle
                        ? Container(
                            color: context.theme.scaffoldBackgroundColor,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(),
                  ],
                ),
        ),
      ),
    );
  }
}

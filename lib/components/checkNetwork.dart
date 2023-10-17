import 'dart:io';

import 'package:flutter/material.dart';

bool isNetwork = false;
Future checkNetwork() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Future.delayed(Duration(seconds: 100), () async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isNetwork = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      isNetwork = false;
    }
  // });
}

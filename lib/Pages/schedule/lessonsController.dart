import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_university_isuct/api/ru_isuct.dart';
import '../../components/weekNumber.dart';

class LessonsController extends GetxController {
  RxBool week1 = false.obs;
  RxBool week2 = false.obs;
  var isLoading = false.obs;
  var thisWeek = weekNumber(DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day))
      .obs;
  @override
  void onInit() {
    super.onInit();
    if (thisWeek % 2 != 0) {
      week1.value = true;
      week2.value = false;
    } else if (thisWeek % 2 == 0) {
      week1.value = false;
      week2.value = true;
    } else {
      week1.value = false;
      week2.value = false;
    }
  }

  void onRefresh() async {
    isLoading.value = true;
    await getISUCT();
    update();
    isLoading.value = false;
  }

  final key = GlobalKey();

  double getSize() {
    final size = key.currentContext!.size;
    if (size != null) {
      final _width = size.width;
      final _height = size.height;
      return _height / _width;
    }
    return 0;
  }
}

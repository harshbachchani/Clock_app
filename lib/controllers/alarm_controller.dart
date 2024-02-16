import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlarmController extends GetxController {
  RxString alarm = DateTime.now().toIso8601String().obs;
  RxBool isRepeating = true.obs;
  List<RxBool> isAlarmsActive = <RxBool>[];
  RxInt weekday = DateTime.now().weekday.obs - 1;
  RxString alarmtime = TimeOfDay.now().toString().obs;
  changeTime(String i) {
    alarm.value = i;
  }

  changealarmtime(String i) {
    alarmtime.value = i;
  }

  changeWeekDay(int i) {
    weekday.value = i;
  }

  setRepeat(bool flag) {
    isRepeating.value = flag;
  }

  toggleRepeat() {
    isRepeating.value = !isRepeating.value;
  }
}

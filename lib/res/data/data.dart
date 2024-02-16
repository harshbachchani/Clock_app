import 'package:alarm_app/models/menu_info.dart';
import 'package:alarm_app/models/timer_info.dart';
import 'package:flutter/cupertino.dart';

List<TimerInfo> defaulttimers = [
  TimerInfo(title: "Brush Teeth", hour: 0, minute: 2, second: 0),
  TimerInfo(title: "Face Mask", hour: 0, minute: 10, second: 0),
  TimerInfo(title: "Boil Eggs", hour: 0, minute: 15, second: 0),
  TimerInfo(title: "Hour Timer", hour: 1, minute: 0, second: 0)
];
List<MenuInfo> menulist = [
  MenuInfo(0, CupertinoIcons.clock),
  MenuInfo(1, CupertinoIcons.alarm),
  MenuInfo(2, CupertinoIcons.stopwatch),
  MenuInfo(3, CupertinoIcons.timer),
];

import 'dart:async';

import 'package:alarm/alarm.dart';

import 'package:alarm_app/controllers/menu_controller.dart';
import 'package:alarm_app/res/components/menu_button.dart';
import 'package:alarm_app/res/data/data.dart';
import 'package:alarm_app/screens/alarm_page.dart';
import 'package:alarm_app/screens/alarmringscreen.dart';
import 'package:alarm_app/screens/clock_page.dart';
import 'package:alarm_app/screens/stopwatch_page.dart';
import 'package:alarm_app/screens/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomepageScreen extends StatefulWidget {
  const MyHomepageScreen({super.key});

  @override
  State<MyHomepageScreen> createState() => _MyHomepageScreenState();
}

class _MyHomepageScreenState extends State<MyHomepageScreen> {
  late double heigh;
  late double weigh;
  static StreamSubscription<AlarmSettings>? dataStream;
  @override
  void initState() {
    super.initState();
    dataStream ??= Alarm.ringStream.stream.listen(
      (event) {
        navigateToRingScreen(event);
      },
    );
  }

  @override
  void dispose() {
    dataStream?.cancel();
    super.dispose();
  }

  PageController mypagecontroller = PageController();
  final List<Widget> _pages = [
    const ClockPage(),
    const AlarmPage(),
    const MyStopWatch(),
    const TimerPage()
  ];
  MyMenuController menuController = Get.put(MyMenuController());

  @override
  Widget build(BuildContext context) {
    Brightness current = Theme.of(context).brightness;
    Color backgroundColor =
        current != Brightness.light ? Colors.black : Colors.white;

    heigh = MediaQuery.of(context).size.height;
    weigh = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: heigh,
            width: weigh,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: menulist
                        .map((e) => MenuButton(
                            currentmenu: e.item,
                            pageController: mypagecontroller))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: mypagecontroller,
                    children: _pages,
                    onPageChanged: (value) {
                      menuController.updateMenu(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  giveWidget(int value) {
    switch (value) {
      case 0:
        return const ClockPage();
      case 1:
        return const AlarmPage();
      case 2:
        return const MyStopWatch();
      case 3:
        return const TimerPage();
    }
  }

  void navigateToRingScreen(AlarmSettings alarmsetting) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlarmRingScreen(
                  alarmSettings: alarmsetting,
                )));
  }
}

import 'dart:async';
import 'package:alarm_app/controllers/stop_watch_controller.dart';
import 'package:alarm_app/res/fonts/appfont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyStopWatch extends StatefulWidget {
  const MyStopWatch({super.key});

  @override
  State<MyStopWatch> createState() => _MyStopWatchState();
}

class _MyStopWatchState extends State<MyStopWatch> {
  late double heigh;
  late double wid;
  Timer? timer;
  StopWatchController controller = Get.put(StopWatchController());

  @override
  void dispose() {
    super.dispose();
  }
  //stop timer function

  void stop() {
    timer!.cancel();
    controller.updateStart(false);
  }

  //reset function
  void reset() {
    timer!.cancel();
    controller.updateStart(false);
    controller.laps.clear();
    controller.flags.clear();
    controller.updatevalues(0, 0, 0);
  }

  void addlaps() {
    String updateSecond = controller.digitsecond.value;
    String updateminute = controller.digitminute.value;
    String updatehour = controller.digithour.value;

    if (controller.laps.isNotEmpty) {
      String temp1 = controller.laps[controller.laps.length - 1];
      String temp2 =
          "${controller.digithour.value}:${controller.digitminute.value}:${controller.digitsecond.value}";
      DateTime dateTime1 = DateTime.parse("2022-01-01 $temp2");
      DateTime dateTime2 = DateTime.parse("2022-01-01 $temp1");
      Duration diff = dateTime1.difference(dateTime2);
      debugPrint(diff.toString());
      updatehour = "0${diff.toString().substring(0, 1)}";
      updateminute = diff.toString().substring(2, 4);
      updateSecond = diff.toString().substring(5, 7);
    }
    String flag = "$updatehour:$updateminute:$updateSecond";
    controller.addFlag(flag);
    controller.addlap();
  }
  //start function

  void start() {
    controller.updateStart(true);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localsecond = controller.seconds.value + 1;
      int localminute = controller.minutes.value;
      int localhour = controller.hours.value;
      if (localsecond > 59) {
        if (localminute > 59) {
          localhour++;
          localminute = 0;
          localsecond = 0;
        } else {
          localminute++;
          localsecond = 0;
        }
      }
      controller.updatevalues(localhour, localminute, localsecond);
    });
  }

  @override
  void initState() {
    super.initState();
    heigh = Get.height;
    wid = Get.width;
  }

  @override
  Widget build(BuildContext context) {
    Brightness current = Theme.of(context).brightness;
    Color backgroundColor =
        current != Brightness.light ? Colors.black : Colors.white;
    Color textColor = current == Brightness.light ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Text(
                    "${controller.digithour.value}:${controller.digitminute.value}:${controller.digitsecond.value}",
                    style: AppFont.mediumText(70, textColor)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                    height: heigh * 0.55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: textColor, width: 2)),
                    child: Obx(
                      () => ListView.builder(
                        itemCount: controller.laps.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.flag,
                                        color: textColor, size: 30),
                                    SizedBox(width: wid * 0.02),
                                    Text(
                                      index < 9
                                          ? "0${index + 1}"
                                          : "${index + 1}",
                                      style: AppFont.mediumText(25, textColor),
                                    )
                                  ],
                                ),
                                Text("+${controller.flags[index]}",
                                    style: AppFont.mediumText(25, textColor)),
                                Text(controller.laps[index],
                                    style: AppFont.mediumText(25, textColor))
                              ],
                            ),
                          );
                        },
                      ),
                    )),
              ),
              SizedBox(height: heigh * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        (!controller.started.value) ? start() : stop();
                      },
                      shape: const StadiumBorder(),
                      fillColor: textColor,
                      child: Obx(
                        () => Text(!controller.started.value ? "Start" : "Stop",
                            style: TextStyle(
                                color: backgroundColor, fontSize: 15)),
                      ),
                    ),
                  ),
                  SizedBox(width: wid * 0.02),
                  IconButton(
                    onPressed: () {
                      if (controller.started.value) {
                        addlaps();
                      }
                    },
                    color: textColor,
                    iconSize: 30,
                    icon: const Icon(Icons.flag),
                  ),
                  SizedBox(width: wid * 0.02),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        reset();
                      },
                      shape: const StadiumBorder(),
                      fillColor: textColor,
                      child: Text("Reset",
                          style:
                              TextStyle(color: backgroundColor, fontSize: 15)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

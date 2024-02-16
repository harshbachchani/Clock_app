import 'dart:async';
import 'package:alarm_app/controllers/timer_controller.dart';
import 'package:alarm_app/models/timer_info.dart';
import 'package:alarm_app/res/components/dialogbox.dart';
import 'package:alarm_app/res/components/time_input.dart';
import 'package:alarm_app/res/components/timercard.dart';
import 'package:alarm_app/res/fonts/appfont.dart';
import 'package:alarm_app/service/timer_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef MyFunctionType = TimerHelper Function();

class TimerPage extends StatefulWidget {
  static late MyFunctionType getTimers;
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late double heigh;
  Future<List<TimerInfo>>? _timers;
  static final TimerHelper _timerHelper = TimerHelper();
  List<TimerInfo>? _currenttimers;
  TimerController controller = Get.put(TimerController());
  late double wid;
  Timer? timer;

  @override
  void initState() {
    heigh = Get.height;
    wid = Get.width;
    _timerHelper.initializeDatabase().then((value) {
      loadTimers();
    });
    TimerPage.getTimers = () {
      loadTimers();
      return _timerHelper;
    };
    super.initState();
  }

  void loadTimers() {
    _timers = _timerHelper.getTimers();
    if (mounted) {
      setState(() {});
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int hour = controller.hour.value;
      int minute = controller.minute.value;
      int second = controller.second.value;
      if (second == 0 && minute == 0 && hour == 0) {
        controller.changeStarted(false);
        controller.toggleplaying();
        timer.cancel();
      } else if (second == 0) {
        if (minute == 0) {
          hour--;
          minute = 59;
        } else {
          minute--;
          second = 59;
        }
      } else {
        second--;
      }
      controller.settimer(hour, minute, second);
    });
  }

  void stopTimer() {
    timer!.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: heigh * 0.2,
              child: Obx(
                () => TimerCard(
                    hour: controller.dhour.value,
                    minute: controller.dminute.value,
                    second: controller.dsecond.value),
              ),
            ),
            Obx(
              () => SizedBox(
                height: heigh * 0.57,
                child: !controller.isstarted.value
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Frequently Used Timers",
                                style: AppFont.mediumText(15, textColor),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    TextEditingController
                                        textEditingController =
                                        TextEditingController();
                                    showModalBottomSheet(
                                      elevation: 4,
                                      backgroundColor: Colors.white,
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: heigh * 0.6,
                                          width: wid,
                                          child: showBottom(
                                              textEditingController,
                                              true,
                                              null),
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Add",
                                      style:
                                          AppFont.regularText(20, textColor)))
                            ],
                          ),
                          SizedBox(height: heigh * 0.02),
                          Container(
                            height: heigh * 0.4,
                            margin: EdgeInsets.only(bottom: heigh * 0.03),
                            child: FutureBuilder(
                              future: _timers,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Text("Loading...",
                                        style:
                                            AppFont.mediumText(30, textColor)),
                                  );
                                }
                                _currenttimers = snapshot.data;
                                return ListView(
                                  children:
                                      _currenttimers!.map<Widget>((timer) {
                                    String h = timer.hour < 10
                                        ? "0${timer.hour}"
                                        : timer.hour.toString();
                                    String m = timer.minute < 10
                                        ? "0${timer.minute}"
                                        : timer.minute.toString();
                                    String s = timer.second < 10
                                        ? "0${timer.second}"
                                        : timer.second.toString();
                                    return GestureDetector(
                                      onLongPress: () {
                                        TextEditingController
                                            textEditingController =
                                            TextEditingController(
                                                text: timer.title);
                                        showModalBottomSheet(
                                            elevation: 4,
                                            backgroundColor: Colors.white,
                                            isScrollControlled: true,
                                            isDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return SizedBox(
                                                height: heigh * 0.6,
                                                width: wid,
                                                child: showBottom(
                                                    textEditingController,
                                                    false,
                                                    timer),
                                              );
                                            });
                                      },
                                      onTap: () {
                                        controller.settimer(timer.hour,
                                            timer.minute, timer.second);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(4),
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blueGrey.shade200,
                                        ),
                                        child: myListTile(timer, h, m, s,
                                            textColor, backgroundColor),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              controller.changeStarted(true);
                              controller.toggleplaying();
                              startTimer();
                            },
                            child: const Icon(Icons.play_arrow),
                          )
                        ],
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                controller.settimer(0, 0, 0);
                                stopTimer();
                                controller.changeStarted(false);
                              },
                              child: const Icon(Icons.cancel, size: 35),
                            ),
                            FloatingActionButton(
                                onPressed: () {
                                  controller.toggleplaying();
                                  if (controller.isplaying.value) {
                                    startTimer();
                                  } else {
                                    stopTimer();
                                  }
                                },
                                child: !controller.isplaying.value
                                    ? const Icon(Icons.play_arrow, size: 35)
                                    : const Icon(Icons.pause, size: 35))
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showBottom(TextEditingController textEditingController, bool flag,
      TimerInfo? timerInf) {
    Color textColor = Colors.black;
    if (!flag) {
      controller.setvalue(timerInf!.hour, 1);
      controller.setvalue(timerInf.minute, 2);
      controller.setvalue(timerInf.second, 3);
    } else {
      controller.setvalue(0, 1);
      controller.setvalue(0, 2);
      controller.setvalue(0, 3);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  textEditingController.dispose();
                  Navigator.pop(context);
                },
                child:
                    Text('Cancel', style: AppFont.mediumText(20, textColor))),
            Text(
              flag ? 'Add Timer' : "Update Timer",
              style: AppFont.smallText(30, textColor),
            ),
            ElevatedButton(
                onPressed: () {
                  String title = textEditingController.text == ""
                      ? "Timer"
                      : textEditingController.text;
                  TimerInfo t = TimerInfo(
                      title: title,
                      hour: controller.timerhour.value,
                      minute: controller.timerminute.value,
                      second: controller.timersecond.value);
                  if (flag) {
                    _timerHelper.insertTimer(t);
                  } else {
                    _timerHelper.updateTimer(timerInf!.id, t);
                  }
                  loadTimers();
                  textEditingController.dispose();
                  Navigator.pop(context);
                },
                child: Text('Done', style: AppFont.mediumText(20, textColor))),
          ],
        ),
        SizedBox(height: heigh * 0.03),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            autofocus: true,
            controller: textEditingController,
            textAlign: TextAlign.center,
            style: AppFont.mediumText(20, textColor),
            maxLength: 20,
            decoration: const InputDecoration(
              labelText: "Title",
              labelStyle: TextStyle(
                color: Color.fromARGB(255, 28, 28, 28),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Hour", style: AppFont.mediumText(30, textColor)),
              Text("Minute", style: AppFont.mediumText(30, textColor)),
              Text("Second", style: AppFont.mediumText(30, textColor))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: heigh * 0.2,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20),
              TimerInput(range: "23", option: 1),
              TimerInput(range: "59", option: 2),
              TimerInput(range: "59", option: 3),
            ],
          ),
        ),
      ],
    );
  }

  Widget myListTile(TimerInfo timer, String h, String m, String s,
      Color primary, Color secondary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.timer,
          color: primary,
        ),
        Text(timer.title, style: AppFont.smallText(25, primary)),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "$h:$m:$s",
              style: AppFont.regularText(35, primary),
            ),
            IconButton(
                onPressed: () {
                  MyDialog.showCustomDialog(context,
                      height: heigh * 0.3,
                      width: wid,
                      child: deleteDialog(timer, primary, secondary));
                },
                icon: const Icon(
                  Icons.delete,
                  size: 30,
                  color: Color.fromRGBO(230, 26, 26, 0.584),
                ))
          ],
        )
      ],
    );
  }

  Widget deleteDialog(TimerInfo a, Color primary, Color secondary) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: primary,
      child: Column(
        children: [
          Text("Do You Really Want to Delete this Alarm?",
              style: AppFont.mediumText(25, secondary)),
          SizedBox(height: heigh * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      Text('Cancel', style: AppFont.mediumText(25, secondary))),
              TextButton(
                  onPressed: () {
                    _timerHelper.deletetimer(a.id!);
                    loadTimers();
                    Navigator.pop(context);
                  },
                  child: Text('Confirm',
                      style: AppFont.mediumText(25, secondary))),
            ],
          )
        ],
      ),
    );
  }
}

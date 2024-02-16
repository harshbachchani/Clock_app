import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:alarm_app/controllers/alarm_controller.dart';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:alarm_app/res/fonts/appfont.dart';
import 'package:alarm_app/service/alarm_helper.dart';
import 'package:alarm_app/service/alarm_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateDialogue extends StatefulWidget {
  final double height;
  final double width;
  final AlarmHelper alarmHelper;
  final bool flag;
  final AlarmInfo? alarmInfo;
  final Function onSave;

  const UpdateDialogue(
      {super.key,
      required this.height,
      required this.width,
      required this.onSave,
      required this.flag,
      required this.alarmInfo,
      required this.alarmHelper});

  @override
  State<UpdateDialogue> createState() => _UpdateDialogueState();
}

class _UpdateDialogueState extends State<UpdateDialogue> {
  List<String> weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  TextEditingController textEditingController = TextEditingController();
  TextEditingController updateText = TextEditingController();
  AlarmController mymodel = Get.put(AlarmController());
  AlarmController updatemodel = Get.put(AlarmController());
  @override
  void initState() {
    super.initState();
    if (widget.alarmInfo != null) {
      updateText.text = widget.alarmInfo!.title;
      updatemodel.changeTime(widget.alarmInfo!.alarmDateTime.toIso8601String());
      updatemodel.changeWeekDay(widget.alarmInfo!.alarmDateTime.weekday - 1);
      updatemodel.setRepeat(widget.alarmInfo!.isRepeating == 0 ? false : true);
      TimeOfDay t = TimeOfDay(
          hour: widget.alarmInfo!.alarmDateTime.hour,
          minute: widget.alarmInfo!.alarmDateTime.minute);
      updatemodel.changealarmtime(t.toString());
    } else {
      mymodel.changeTime(DateTime.now().toIso8601String());
      mymodel.changeWeekDay(DateTime.now().weekday - 1);
      mymodel.setRepeat(true);
      mymodel.changealarmtime(TimeOfDay.now().toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: widget.height * 0.02,
          ),
          TextField(
            cursorColor: textColor,
            maxLength: 20,
            controller: !widget.flag ? textEditingController : updateText,
            autofocus: true,
            decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                    fontSize: 25,
                    color: textColor,
                    fontWeight: FontWeight.bold),
                alignLabelWithHint: false,
                hintText: "Enter the Title of Alarm",
                icon: Icon(
                  Icons.alarm_outlined,
                  color: textColor,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                )),
          ),
          SizedBox(
            height: widget.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Obx(
                  () => Text(
                    !widget.flag
                        ? mymodel.alarmtime.value.substring(10, 15)
                        : updatemodel.alarmtime.value.substring(10, 15),
                    style: AppFont.headText(30, textColor),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? pickedtime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (pickedtime != null) {
                    if (!widget.flag) {
                      mymodel.changealarmtime(pickedtime.toString());
                    } else {
                      updatemodel.changealarmtime(pickedtime.toString());
                    }
                  }
                },
                child: Text(
                  'Select Time',
                  style: AppFont.mediumText(15, textColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: widget.height * 0.01,
          ),
          SizedBox(
            height: widget.height * 0.05,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(5),
              scrollDirection: Axis.horizontal,
              itemCount: weekdays.length,
              itemBuilder: (context, index) {
                return Obx(
                  () => GestureDetector(
                    onTap: () {
                      !widget.flag
                          ? mymodel.weekday.value = index
                          : updatemodel.weekday.value = index;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: widget.height * 0.02,
                      width: widget.width * 0.11,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: (!widget.flag
                                  ? index == mymodel.weekday.value
                                  : index == updatemodel.weekday.value)
                              ? Colors.cyan.shade300
                              : Colors.cyan.shade100,
                          border: Border.all(color: Colors.black, width: 0.5)),
                      child: Text(
                        weekdays[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black26, fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: widget.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Repeated', style: AppFont.smallText(40, textColor)),
              Obx(
                () => Switch(
                    value: mymodel.isRepeating.value,
                    onChanged: (bool? val) {
                      !widget.flag
                          ? mymodel.toggleRepeat()
                          : updatemodel.toggleRepeat();
                    }),
              )
            ],
          ),
          SizedBox(height: widget.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  String title = !widget.flag
                      ? textEditingController.text
                      : updateText.text;
                  DateTime nowDate = DateTime.now();
                  TimeOfDay nowtime = TimeOfDay.now();
                  late DateTime alarmtime;
                  int hour = int.parse(!widget.flag
                      ? mymodel.alarmtime.value.substring(10, 12)
                      : updatemodel.alarmtime.value.substring(10, 12));
                  int minute = int.parse(!widget.flag
                      ? mymodel.alarmtime.value.substring(13, 15)
                      : updatemodel.alarmtime.value.substring(13, 15));
                  DateTime tempTime = DateTime(
                      nowDate.year, nowDate.month, nowDate.day, hour, minute);
                  int myweekday = !widget.flag
                      ? mymodel.weekday.value
                      : updatemodel.weekday.value;
                  if (nowDate.weekday == myweekday + 1) {
                    if ((hour == nowtime.hour && minute <= nowtime.minute) ||
                        hour < nowtime.hour) {
                      alarmtime = tempTime.add(const Duration(days: 7));
                    } else {
                      alarmtime = tempTime;
                    }
                  } else {
                    int temp = 0;
                    if (myweekday + 1 > nowDate.weekday) {
                      temp = myweekday + 1 - nowDate.weekday;
                    } else {
                      temp = 7 - nowDate.weekday + myweekday + 1;
                    }
                    alarmtime = tempTime.add(Duration(days: temp));
                  }
                  Random r = Random();
                  int alarmid = r.nextInt(5000);
                  AlarmInfo myalarm = AlarmInfo(
                    title: title == "" ? "Your Alarm" : title,
                    alarmDateTime: alarmtime,
                    isActive: 1,
                    alarmID: widget.flag ? widget.alarmInfo!.alarmID : alarmid,
                    isRepeating: !widget.flag
                        ? ((mymodel.isRepeating.value) ? 1 : 0)
                        : ((updatemodel.isRepeating.value) ? 1 : 0),
                  );
                  if (widget.flag) {
                    widget.alarmHelper
                        .updateAlarm(widget.alarmInfo!.id, myalarm);
                  } else {
                    widget.alarmHelper.insertAlarm(myalarm);
                  }
                  widget.onSave();
                  onSaveAlarm(myalarm);
                  Navigator.pop(context);
                },
                child: Text(widget.flag ? "Update" : "Save"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void onSaveAlarm(AlarmInfo myalarm) async {
    MyAlarm m = MyAlarm(
        id: myalarm.alarmID,
        alarmDateTime: myalarm.alarmDateTime,
        title: myalarm.title);
    AlarmSettings a = m.getAlarmsetting();
    var result = await Alarm.set(alarmSettings: a);

    debugPrint(result.toString());
  }
}

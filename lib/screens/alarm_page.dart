import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm_app/controllers/alarm_controller.dart';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:alarm_app/res/components/dialogbox.dart';
import 'package:alarm_app/res/components/updatedialogue.dart';
import 'package:alarm_app/res/fonts/appfont.dart';
import 'package:alarm_app/service/alarm_helper.dart';
import 'package:alarm_app/service/alarm_notification.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

typedef MyFunctionType = AlarmHelper Function();

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});
  static late MyFunctionType getAlarm;
  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late double heigh;
  static final AlarmHelper _alarmHelper = AlarmHelper();
  late double weigh;

  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentalarms;
  AlarmController mymodel = Get.put(AlarmController());
  TextEditingController textEditingController = TextEditingController();
  bool isrepeated = true;
  List<String> weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  List<String> weekname = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thrusday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  late AlarmSettings a;
  @override
  void initState() {
    _alarmHelper.initializeDatabase().then((value) {
      loadAlarms();
    });
    AlarmPage.getAlarm = () {
      loadAlarms();
      return _alarmHelper;
    };
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    heigh = MediaQuery.of(context).size.height;
    weigh = MediaQuery.of(context).size.width;
    Brightness current = Theme.of(context).brightness;
    Color textColor = current == Brightness.light ? Colors.black : Colors.white;
    Color backgroundColor =
        current != Brightness.light ? Colors.black : Colors.white;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: weigh * 0.04, vertical: heigh * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder<List<AlarmInfo>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("Loading...",
                        style: AppFont.mediumText(30, textColor)),
                  );
                }
                _currentalarms = snapshot.data;
                return ListView(
                  children: _currentalarms!.map<Widget>((alarm) {
                    return GestureDetector(
                      onTap: () {
                        mymodel.changeTime(alarm.alarmDateTime.toString());
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: heigh * 0.55,
                              width: weigh,
                              child: UpdateDialogue(
                                height: heigh,
                                width: weigh,
                                flag: true,
                                onSave: () {
                                  loadAlarms();
                                },
                                alarmInfo: alarm,
                                alarmHelper: _alarmHelper,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: heigh * 0.02),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: current == Brightness.light
                              ? const Color.fromARGB(255, 198, 230, 235)
                              : const Color.fromARGB(255, 204, 221, 236),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.label,
                                      color: textColor,
                                      size: 24,
                                    ),
                                    SizedBox(width: weigh * 0.03),
                                    Text(alarm.title,
                                        style: AppFont.smallText(25, textColor))
                                  ],
                                ),
                                Switch(
                                  activeColor: textColor,
                                  value: alarm.isActive != 0,
                                  onChanged: (value) {
                                    if (!value) {
                                      stopAlarm(alarm.alarmID);
                                    } else {
                                      MyAlarm a = MyAlarm(
                                          id: alarm.alarmID,
                                          alarmDateTime: alarm.alarmDateTime,
                                          title: alarm.title);
                                      AlarmSettings mysetting =
                                          a.getAlarmsetting();
                                      Alarm.set(alarmSettings: mysetting);
                                    }
                                    _alarmHelper.updateActiveness(
                                        alarm.id!, value ? 1 : 0);
                                    loadAlarms();
                                  },
                                ),
                              ],
                            ),
                            Text(
                                "${weekname[alarm.alarmDateTime.weekday - 1]}|${alarm.isRepeating == 0 ? "Ring Once" : "Repeated"}",
                                style: AppFont.mediumText(25, textColor)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    DateFormat('MM-dd HH:mm')
                                        .format(alarm.alarmDateTime),
                                    style: AppFont.mediumText(25, textColor)),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      size: 30, color: Colors.red),
                                  onPressed: () {
                                    MyDialog.showCustomDialog(context,
                                        height: heigh * 0.3,
                                        width: weigh,
                                        child: deleteDialog(
                                            alarm, backgroundColor, textColor));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }).followedBy([
                    DottedBorder(
                      strokeWidth: 3,
                      color: const Color.fromARGB(255, 135, 82, 234),
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(24),
                      child: Container(
                        width: weigh,
                        height: heigh * 0.12,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 216, 205, 237),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TextButton(
                          onPressed: () async {
                            showModalBottomSheet(
                              isDismissible: false,
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: heigh * 0.55,
                                  width: weigh,
                                  child: UpdateDialogue(
                                    height: heigh,
                                    width: weigh,
                                    onSave: () {
                                      loadAlarms();
                                    },
                                    alarmInfo: null,
                                    flag: false,
                                    alarmHelper: _alarmHelper,
                                  ),
                                );
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_alarm, size: 40, color: textColor),
                              SizedBox(height: heigh * 0.01),
                              Text(
                                'Add Alarm',
                                style: AppFont.mediumText(20, textColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ]).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void onSaveAlarm(AlarmInfo alarm) {
    loadAlarms();
  }

  void deleteAlarm(int? id) {
    _alarmHelper.deletealarm(id!);
    loadAlarms();
  }

  Widget deleteDialog(AlarmInfo a, Color secondary, Color primary) {
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
                    stopAlarm(a.alarmID);
                    _alarmHelper.deletealarm(a.id!);
                    loadAlarms();
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

  void stopAlarm(int id) async {
    await Alarm.stop(id);
    _alarmHelper.updateActive(id, 0);
    loadAlarms();
  }
}

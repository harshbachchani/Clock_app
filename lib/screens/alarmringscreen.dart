import 'package:alarm/alarm.dart';
import 'package:alarm_app/res/fonts/appfont.dart';
import 'package:alarm_app/screens/alarm_page.dart';

import 'package:flutter/material.dart';

class AlarmRingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingScreen({super.key, required this.alarmSettings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(95, 219, 173, 173),
        body: SafeArea(
          child: Center(
            child: Column(children: [
              Text("Your Alarm (${alarmSettings.id}) is ringing...",
                  style: AppFont.mediumText(30)),
              const Text("🔔", style: TextStyle(fontSize: 50)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      final now = DateTime.now();
                      Alarm.set(
                        alarmSettings: alarmSettings.copyWith(
                          dateTime: DateTime(
                            now.year,
                            now.month,
                            now.day,
                            now.hour,
                            now.minute,
                            0,
                            0,
                          ).add(const Duration(minutes: 5)),
                        ),
                      ).then((_) => Navigator.pop(context));
                    },
                    child: Text(
                      "Snooze",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      AlarmPage.getAlarm().updateActive(alarmSettings.id, 0);
                      Alarm.stop(alarmSettings.id);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Stop",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}

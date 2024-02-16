import 'package:alarm/alarm.dart';

class MyAlarm {
  final int id;
  final DateTime alarmDateTime;
  final String title;
  const MyAlarm({
    required this.id,
    required this.alarmDateTime,
    required this.title,
  });

  AlarmSettings getAlarmsetting() {
    var alarmSetting = AlarmSettings(
        id: id,
        dateTime: alarmDateTime,
        assetAudioPath: 'assets/alarm_ringtone.mp3',
        notificationTitle: title,
        vibrate: true,
        loopAudio: true,
        androidFullScreenIntent: true,
        volume: 0.9,
        notificationBody: 'Your alarm with title: $title');
    return alarmSetting;
  }
}

import 'package:alarm_app/models/timer_info.dart';
import 'package:alarm_app/res/data/data.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

const String tableName = 'timer';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnhour = 'hour';
const String columnminute = 'minute';
const String columnsecond = 'second';

class TimerHelper {
  static Database? _database;
  static TimerHelper? _alarmHelper;

  TimerHelper._createInstance();
  factory TimerHelper() {
    _alarmHelper ??= TimerHelper._createInstance();
    return _alarmHelper!;
  }
  Future<Database> get database async {
    _database ??= await initializeDatabase();

    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = "$dir/timer.db";
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        try {
          await db.execute('''
          create table $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnhour INTEGER,
            $columnsecond INTEGER,
            $columnminute INTEGER NOT NULL
            )
        ''');
          for (var timer in defaulttimers) {
            db.insert(tableName, timer.toJson());
          }
        } catch (e) {
          debugPrint("Error is $e");
        }
      },
    );
    return database;
  }

  void insertTimer(TimerInfo timerInfo) async {
    var db = await database;
    var result = await db.insert(tableName, timerInfo.toJson());
    debugPrint(result.toString());
  }

  Future<List<TimerInfo>> getTimers() async {
    List<TimerInfo> timers = [];
    var db = await database;
    var result = await db.query(tableName);
    for (var element in result) {
      var timerInfo = TimerInfo.fromJson(element);
      timers.add(timerInfo);
    }
    return timers;
  }

  // void updateActiveness(int id, int value) async {
  //   var db = await database;
  //   var result = await db.update(tableName, {columnActive: value},
  //       where: '$columnId = ?', whereArgs: [id]);
  //   debugPrint(result.toString());
  // }

  // void updateActive(int alarmId, int value) async {
  //   var db = await database;
  //   var result = await db.update(tableName, {columnActive: value},
  //       where: '$columnAlarmId = ?', whereArgs: [alarmId]);
  //   debugPrint(result.toString());
  // }

  void updateTimer(int? id, TimerInfo a) async {
    var db = await database;
    var result = await db.update(
        tableName,
        {
          columnTitle: a.title,
          columnhour: a.hour,
          columnminute: a.minute,
          columnsecond: a.second
        },
        where: '$columnId = ?',
        whereArgs: [id]);
    debugPrint(result.toString());
  }

  Future<int> deletetimer(int id) async {
    var db = await database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}

import 'package:alarm_app/models/alarm_info.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

const String tableName = 'alarm';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnActive = 'isActive';
const String columnRepeating = 'isRepeating';
const String columnAlarmId = 'alarmID';

class AlarmHelper {
  static Database? _database;
  static AlarmHelper? _alarmHelper;

  AlarmHelper._createInstance();
  factory AlarmHelper() {
    _alarmHelper ??= AlarmHelper._createInstance();
    return _alarmHelper!;
  }
  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = "$dir/alarms.db";
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        try {
          await db.execute('''
          create table $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnDateTime TEXT NOT NULL,
            $columnActive INTEGER,
            $columnRepeating INTEGER,
            $columnAlarmId INTEGER NOT NULL
            )
        ''');
        } catch (e) {
          debugPrint("Error is $e");
        }
      },
    );
    return database;
  }

  void insertAlarm(AlarmInfo alarmInfo) async {
    var db = await database;
    var result = await db.insert(tableName, alarmInfo.toJson());
    debugPrint(result.toString());
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> alarms = [];
    var db = await database;
    var result = await db.query(tableName);
    for (var element in result) {
      var alarmInfo = AlarmInfo.fromJson(element);
      alarms.add(alarmInfo);
    }
    return alarms;
  }

  void updateActiveness(int id, int value) async {
    var db = await database;
    var result = await db.update(tableName, {columnActive: value},
        where: '$columnId = ?', whereArgs: [id]);
    debugPrint(result.toString());
  }

  void updateActive(int alarmId, int value) async {
    var db = await database;
    var result = await db.update(tableName, {columnActive: value},
        where: '$columnAlarmId = ?', whereArgs: [alarmId]);
    debugPrint(result.toString());
  }

  void updateAlarm(int? id, AlarmInfo a) async {
    var db = await database;
    var result = await db.update(
        tableName,
        {
          columnTitle: a.title,
          columnActive: a.isActive,
          columnRepeating: a.isRepeating,
          columnDateTime: a.alarmDateTime.toIso8601String()
        },
        where: '$columnId = ?',
        whereArgs: [id]);
    debugPrint(result.toString());
  }

  Future<int> deletealarm(int id) async {
    var db = await database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}

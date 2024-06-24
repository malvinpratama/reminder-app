import 'package:sqflite/sqflite.dart';

import '../models/models.dart';

class TimeReminderRepository {
  TimeReminderRepository(
    Future<Database> database,
  ) : _database = database;

  final Future<Database> _database;

  Future<List<TimeRemindersModel>> getReminder() async {
    final now = DateTime.now();
    final start =
        now.add(Duration(seconds: -now.second)).millisecondsSinceEpoch;
    final end = now
        .add(Duration(seconds: -now.second, minutes: 1))
        .millisecondsSinceEpoch;

    final db = await _database;
    return await db.query(TimeRemindersModel.kTableName,
        where: "time > ? AND time < ?", whereArgs: ["$start", "$end"]).then(
      (result) {
        if (result.isNotEmpty) {
          return List.from(result.map(
            (x) {
              return TimeRemindersModel.fromJson(x);
            },
          ));
        }
        return [];
      },
    );
  }

  Future<List<TimeRemindersModel>> getNextReminder() async {
    final now = DateTime.now();
    final start =
        now.add(Duration(seconds: -now.second)).millisecondsSinceEpoch;

    final db = await _database;
    return await db.query(TimeRemindersModel.kTableName,
        where: "time > ?", whereArgs: ["$start"],
        orderBy: "time"
        ).then(
      (result) {
        if (result.isNotEmpty) {
          return List.from(result.map(
            (x) {
              return TimeRemindersModel.fromJson(x);
            },
          ));
        }
        return [];
      },
    );
  }
}

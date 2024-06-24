import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'transaction_db_model.dart';

class TimeRemindersModel {
  static const kTableName = 'time_reminders';

  TimeRemindersModel({
    this.id,
    required this.time,
    this.title,
    this.description,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int time;
  final String? title;
  final String? description;
  final String? note;
  final int createdAt;
  final int updatedAt;

  factory TimeRemindersModel.fromJson(Map<String, dynamic> json) =>
      TimeRemindersModel(
        id: json["id"],
        time: json["time"],
        title: json["title"],
        description: json["description"],
        note: json["note"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time,
        "title": title,
        "description": description,
        "note": note,
        "created_at": createdAt,
        "updated_at": createdAt,
      };

  Future<TransactionDbModel<TimeRemindersModel>> save(Database database) async {
    try {
      final data = toJson();

      return await database
          .insert(
        TimeRemindersModel.kTableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then(
        (id) async {
          tz.initializeTimeZones();
          FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();
          const AndroidInitializationSettings initializationSettingsAndroid =
              AndroidInitializationSettings('ic_launcher');
          const DarwinInitializationSettings initializationSettingsDarwin =
              DarwinInitializationSettings();
          const InitializationSettings initializationSettings =
              InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
          );
          flutterLocalNotificationsPlugin.initialize(initializationSettings);
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission();
          await flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            title,
            description,
            tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, time)
                .add(const Duration(seconds: 30)),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'reminder notification',
                'reminder notification channel',
                channelDescription: 'reminder notification',
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.alarmClock,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
          return TransactionDbModel(model: this, isSuccess: true, error: '');
        },
      );
    } catch (e) {
      return TransactionDbModel(
          model: this, isSuccess: false, error: e.toString());
    }
  }

  Future<TransactionDbModel<TimeRemindersModel>> update(
      Database database) async {
    try {
      final data = toJson();

      return await database
          .update(
        TimeRemindersModel.kTableName,
        data,
        where: "id = ?",
        whereArgs: ["$id"],
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then(
        (id) async {
          tz.initializeTimeZones();
          FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();
          const AndroidInitializationSettings initializationSettingsAndroid =
              AndroidInitializationSettings('ic_launcher');
          const DarwinInitializationSettings initializationSettingsDarwin =
              DarwinInitializationSettings();
          const InitializationSettings initializationSettings =
              InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
          );
          flutterLocalNotificationsPlugin.initialize(initializationSettings);
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission();

          await flutterLocalNotificationsPlugin.cancel(id);

          await flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            title,
            description,
            tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, time)
                .add(const Duration(seconds: 30)),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'reminder notification',
                'reminder notification channel',
                channelDescription: 'reminder notification',
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.alarmClock,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
          return TransactionDbModel(model: this, isSuccess: true, error: '');
        },
      );
    } catch (e) {
      return TransactionDbModel(
          model: this, isSuccess: false, error: e.toString());
    }
  }

  Future<TransactionDbModel<TimeRemindersModel>> delete(
      Database database) async {
    try {
      await database.delete(TimeRemindersModel.kTableName,
          where: "id = ?", whereArgs: [id]);

      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings();
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );
      flutterLocalNotificationsPlugin.initialize(initializationSettings);
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      await flutterLocalNotificationsPlugin.cancel(id!);

      return TransactionDbModel(model: this, isSuccess: true, error: '');
    } catch (e) {
      return TransactionDbModel(
          model: this, isSuccess: false, error: e.toString());
    }
  }
}

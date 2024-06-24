

import '../models/database/time_reminders_model.dart';

class M20240620Init {
  static const query = [
    '''
      CREATE TABLE ${TimeRemindersModel.kTableName} (id INTEGER PRIMARY KEY AUTOINCREMENT,
      time INTEGER, title TEXT, description TEXT, note TEXT, created_at INTEGER, updated_at INTEGER)
    ''',
  ];
}

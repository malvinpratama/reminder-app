
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import '../migrations/migrations.dart';

class DatabaseService {
  // For Not ReCreate
  static final _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;
  static String _databasePath = '';
  static Future<Database> get database async {
    _database ??= await _init();

    return _database!;
  }

  static Future<Database> _init() async {
    _databasePath = path.join(await getDatabasesPath(), 'vesperia.db');
    return await openDatabase(
      _databasePath,
      version: Migrations.updates.length + 1,
      onCreate: (Database db, int version) async {
        final batch = db.batch();

        final initials = [
          [...Migrations.init],
          ...Migrations.updates,
        ];
        for (final queries in initials) {
          for (final query in queries) {
            batch.execute(query);
          }
        }

        await batch.commit(noResult: true);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        final batch = db.batch();

        for (int i = oldVersion - 1; i < newVersion - 1; i++) {
          final queries = Migrations.updates[i];
          for (final query in queries) {
            batch.execute(query);
          }
        }

        await batch.commit(noResult: true);
      },
    );
  }
}

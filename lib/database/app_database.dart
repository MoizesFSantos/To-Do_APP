import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void createDatabase() {
  getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, 'tasks.db');
    openDatabase(path, onCreate: (db, version) {
      db.execute('CREATE TABLE tasks('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'task TEXT, '
          'created_at TEXT, '
          'updated_at TEXT, '
          'deleted_at TEXT)');
    }, version: 1);
  });
}

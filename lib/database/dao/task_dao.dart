import 'package:sqflite/sqflite.dart';
import 'package:to_do/models/task.dart';
import '../app_database.dart';

class TaskDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$_task TEXT,)';
  static const String _tableName = 'tasks';
  static const String _id = 'id';
  static const String _task = 'task';

  Future<int> save(Task task) async {
    final Database db = await getDatabase();
    Map<String, dynamic> taskMap = _toMap(task);
    return db.insert(_tableName, taskMap);
  }

  Future<List<Task>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Task> tasks = _toList(result);
    return tasks;
  }

  Map<String, dynamic> _toMap(Task task) {
    final Map<String, dynamic> taskMap = Map();
    taskMap[_task] = task.task;
    return taskMap;
  }

  List<Task> _toList(List<Map<String, dynamic>> result) {
    final List<Task> tasks = [];
    for (Map<String, dynamic> row in result) {
      final Task task = Task(
        row[_id],
        row[_task],
      );
      tasks.add(task);
    }
    return tasks;
  }
}

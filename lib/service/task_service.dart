import 'package:to_do/database/repository.dart';

import '../models/task.dart';

class TaskService {
  Repository _repository;

  TaskService() {
    _repository = Repository();
  }

  saveTask(Task task) async {
    return await _repository.insertData('tasks', task.taskMap());
  }

  readTasks() async {
    return await _repository.readData('tasks');
  }

  deleteTask(taskId) async {
    return await _repository.deleteData('tasks', taskId);
  }
}

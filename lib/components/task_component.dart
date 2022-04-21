import 'package:flutter/material.dart';
import '../models/task.dart';
import '../service/task_service.dart';

class TaskItem extends StatefulWidget {
  final Task task;

  TaskItem(this.task, {Key key}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TaskService _taskService;

  List<Task> _taskList = List<Task>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        //title: Text(_taskList[index].title ?? 'no Title'),
        subtitle: const Text('test'),
        trailing: IconButton(
          icon: const Icon(
            Icons.check,
            color: Color.fromARGB(246, 81, 199, 128),
          ),
          onPressed: () {
            // _dao.delete(widget.task);
          },
        ),
      ),
    );
  }
}

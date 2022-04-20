import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  TaskItem(this.task, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(task.title),
        subtitle: const Text('test'),
        trailing: IconButton(
          icon: const Icon(
            Icons.check,
            color: Color.fromARGB(246, 81, 199, 128),
          ),
          onPressed: () {
            _dao.delete(task);
          },
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use, prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:to_do/components/task_component.dart';
import 'package:to_do/database/app_database.dart';
import 'package:to_do/service/task_service.dart';
import '../models/task.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var taskObject = Task();
  var task;

  final TextEditingController _taskTitleController = TextEditingController();

  TaskService _taskService;

  List<Task> _taskList = List<Task>();

  @override
  initState() {
    super.initState();
    getAllTasks();
  }

  getAllTasks() async {
    _taskService = TaskService();
    _taskList = List<Task>();

    var tasks = await _taskService.readTasks();
    tasks.forEach((task) {
      setState(() {
        var model = Task();
        model.id = task['id'];
        model.title = task['title'];
        _taskList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 253, 252, 252),
      drawer: const Drawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Color.fromARGB(213, 81, 199, 128),
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'HOME',
          style: TextStyle(color: Color.fromARGB(246, 81, 199, 128)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Dismissible(
            onDismissed: (direction) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${_taskList[index].title} is done')));
            },
            key: Key(_taskList[index].title),
            child: Card(
              elevation: 5,
              child: ListTile(
                title: Text(_taskList[index].title ?? 'no Title'),
                subtitle: const Text('test'),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.check,
                    color: Color.fromARGB(246, 81, 199, 128),
                  ),
                  onPressed: () async {
                    var result =
                        await _taskService.deleteTask(_taskList[index].id);
                    if (result > 0) {
                      getAllTasks();
                    }
                  },
                ),
              ),
            ),
          );
        },
        itemCount: _taskList.length,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(246, 81, 199, 128),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                backgroundColor: const Color.fromARGB(230, 253, 252, 252),
                title: const Text(
                  'New Task',
                  style: TextStyle(
                    color: Color.fromARGB(246, 81, 199, 128),
                  ),
                ),
                content: Material(
                  borderRadius: BorderRadius.circular(3),
                  elevation: 3,
                  child: TextField(
                    controller: _taskTitleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'task...',
                    ),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      taskObject.title = _taskTitleController.text;
                      taskObject.done = false;
                      var _taskService = TaskService();
                      var result = await _taskService.saveTask(taskObject);
                      if (result > 0) {
                        print(result);
                        Navigator.pop(context);
                        getAllTasks();
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: Color.fromARGB(246, 81, 199, 128),
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

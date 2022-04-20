// ignore_for_file: deprecated_member_use, prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:to_do/components/task_component.dart';
import '../database/dao/task_dao.dart';
import '../models/task.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TaskDao _dao = TaskDao();
  final TextEditingController _taskController = TextEditingController();

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
      body: FutureBuilder<List<Task>>(
        initialData: List(),
        future: _dao.findAll(),
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading')
                  ],
                ),
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Task> tasks = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Task task = tasks[index];
                  return TaskItem(task);
                },
                itemCount: tasks.length,
              );
              break;
          }
          return Text('Unknown error');
        },
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
                    controller: _taskController,
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
                    onPressed: () {
                      final String task = _taskController.text;
                      final Task newTask = Task(0, task);
                      _dao.save(newTask).then((id) => Navigator.pop(context));
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

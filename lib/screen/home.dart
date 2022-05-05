// ignore_for_file: deprecated_member_use, prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/drawer_menu.dart';
import 'package:to_do/database/app_database.dart';
import 'package:to_do/screen/new_task.dart';
import 'package:to_do/service/categories_service.dart';
import 'package:to_do/service/task_service.dart';
import '../models/task.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var taskObject = Task();

  final TextEditingController _taskTitleController = TextEditingController();

  TaskService _taskService;

  List<Task> _taskList = List<Task>();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    _loadCategories();
    getAllTasks();
  }

  var _selectedValue;

  var _categories = List<DropdownMenuItem>();

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
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

  _deleteFormDialog(BuildContext context, taskId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: bgColor,
            title: const Text(
              'have you finished this task?',
              style: TextStyle(
                color: pColor,
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: tColor,
                    fontSize: 16,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  var result = await _taskService.deleteTask(taskId);
                  if (result > 0) {
                    print(result);
                    Navigator.pop(context);
                    getAllTasks();
                    _showSuccessSnackBar(Text('Done!'));
                  }
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: pColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        });
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: bgColor,
      drawer: DrawerMenu(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: pColor,
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
          style: TextStyle(color: pColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Dismissible(
            onDismissed: (direction) {
              _deleteFormDialog(context, _taskList[index].id);
            },
            key: Key(_taskList[index].title),
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Card(
                elevation: 6.0,
                child: ListTile(
                  title: Text(
                    _taskList[index].title ?? 'no Title',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  subtitle: const Text('test'),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: pColor,
                    ),
                    onPressed: () {
                      var result =
                          _deleteFormDialog(context, _taskList[index].id);
                      if (result > 0) {
                        getAllTasks();
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: _taskList.length,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: pColor,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskScreen(),
          ),
        ),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

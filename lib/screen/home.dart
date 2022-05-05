// ignore_for_file: deprecated_member_use, prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:to_do/components/drawer_menu.dart';
import 'package:to_do/database/app_database.dart';
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

  _showFormDialog(BuildContext context) {
    return showDialog(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromARGB(246, 81, 199, 128),
                  ),
                  child: DropdownButton(
                    value: _selectedValue,
                    items: _categories,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                    dropdownColor: Color.fromARGB(246, 81, 199, 128),
                    hint: const Text(
                      'Category',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    elevation: 8,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
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
            ),
          ],
        );
      },
    );
  }

  _deleteFormDialog(BuildContext context, taskId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(230, 253, 252, 252),
            title: const Text(
              'have you finished this task?',
              style: TextStyle(
                color: Color.fromARGB(246, 81, 199, 128),
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color.fromARGB(246, 110, 110, 110),
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
                    color: Color.fromARGB(246, 81, 199, 128),
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
      backgroundColor: const Color.fromARGB(230, 253, 252, 252),
      drawer: DrawerMenu(),
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
                      color: Color.fromARGB(246, 81, 199, 128),
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
        backgroundColor: const Color.fromARGB(246, 81, 199, 128),
        onPressed: () {
          _showFormDialog(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

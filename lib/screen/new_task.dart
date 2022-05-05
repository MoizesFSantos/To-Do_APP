import 'package:flutter/material.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/service/task_service.dart';
import '../service/categories_service.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key key}) : super(key: key);
  @override
  State<TaskScreen> createState() => _TaskState();
}

class _TaskState extends State<TaskScreen> {
  var taskObject = Task();

  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _taskDateController = TextEditingController();

  TaskService _taskService;

  List<Task> _taskList = List<Task>();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    _loadCategories();
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

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _taskDateController.text = DateFormat('EEE, d/M/y').format(_pickedDate);
      });
    }
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
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: pColor,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
        centerTitle: true,
        title: const Text(
          'NEW TASK',
          style: TextStyle(color: pColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Material(
                  borderRadius: BorderRadius.circular(3),
                  elevation: 3,
                  child: TextField(
                    controller: _taskTitleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Title',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Material(
                  borderRadius: BorderRadius.circular(3),
                  elevation: 3,
                  child: TextField(
                    controller: _taskDescriptionController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Description',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Material(
                  borderRadius: BorderRadius.circular(3),
                  elevation: 3,
                  child: TextField(
                    controller: _taskDateController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Date',
                        hintText: 'Date',
                        prefixIcon: InkWell(
                          onTap: () {
                            _selectedTodoDate(context);
                          },
                          child: const Icon(
                            Icons.calendar_today,
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Material(
                  borderRadius: BorderRadius.circular(3),
                  elevation: 3,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: pColor,
                    ),
                    child: DropdownButtonFormField(
                      value: _selectedValue,
                      items: _categories,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                      dropdownColor: pColor,
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
                ),
                const SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    var taskObject = Task();

                    taskObject.title = _taskTitleController.text;
                    taskObject.description = _taskDescriptionController.text;
                    taskObject.isFinished = 0;
                    taskObject.category = _selectedValue.toString();
                    taskObject.taskDate = _taskDateController.text;

                    var _taskService = TaskService();
                    var result = await _taskService.saveTask(taskObject);
                    if (result > 0) {
                      _showSuccessSnackBar(Text('Created'));
                      getAllTasks();
                    }
                  },
                  color: sColor,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  var todos = [];

  @override
  void initState() {
    super.initState();
    todos.add('Item1');
    todos.add('Item2');
    todos.add('Item3');
    todos.add('Item4');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(todos[index]),
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text(todos[index]),
              subtitle: const Text('test'),
              trailing: IconButton(
                icon: const Icon(
                  Icons.check,
                  color: Color.fromARGB(246, 81, 199, 128),
                ),
                onPressed: () {
                  setState(() {
                    todos.removeAt(index);
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

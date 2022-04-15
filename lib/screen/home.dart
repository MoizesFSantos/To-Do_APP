// ignore_for_file: deprecated_member_use, prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:to_do/components/task_component.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var todos = [];
  String input = "";

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
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(todos[index]),
              child: Card(
                elevation: 3,
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
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(246, 81, 199, 128),
        onPressed: () => {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('New Task'),
                content: TextField(
                  onChanged: (String value) {
                    input = value;
                  },
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        todos.add(input);
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  )
                ],
              );
            },
          )
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

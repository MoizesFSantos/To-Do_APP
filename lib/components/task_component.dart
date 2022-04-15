import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final todos = List<String>.generate(20, (index) => 'Item ${index + 1}');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            onDismissed: (direction) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${todos[index]} dismissed')));
            },
            key: Key(todos[index]),
            child: Card(
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    title: Text(todos[index]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text(
                        'Priority: 03',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        '29/05/2021',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

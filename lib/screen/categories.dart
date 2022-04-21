import 'package:flutter/material.dart';
import 'package:to_do/components/drawer_menu.dart';

class Categories extends StatefulWidget {
  const Categories({Key key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'CATEGORIES',
          style: TextStyle(color: Color.fromARGB(246, 81, 199, 128)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(),
    );
  }
}

import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(213, 81, 199, 128),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Color.fromARGB(213, 81, 199, 128),
            ),
            title: const Text(
              'HOME',
              style: TextStyle(color: Color.fromARGB(213, 81, 199, 128)),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/home');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.view_list,
              color: Color.fromARGB(213, 81, 199, 128),
            ),
            title: const Text(
              'CATEGORIES',
              style: TextStyle(color: Color.fromARGB(213, 81, 199, 128)),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/categories');
            },
          ),
        ],
      ),
    );
  }
}

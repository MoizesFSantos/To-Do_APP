import 'package:flutter/material.dart';
import 'package:to_do/screen/categories.dart';
import 'package:to_do/screen/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/categories': (context) => const Categories(),
      },
    );
  }
}

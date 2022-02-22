import 'package:flutter/material.dart';
import 'route.dart' as route;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Catalog',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      onGenerateRoute: route.controller,
      initialRoute: route.homePage,
    );
  }
}

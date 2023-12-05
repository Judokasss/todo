import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color.fromARGB(255, 32, 32, 32)));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

final lightTheme = ThemeData(
  // Светлая тема
  brightness: Brightness.light,
);

final darkTheme = ThemeData(
  // Темная тема
  brightness: Brightness.dark,
);

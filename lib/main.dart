import 'package:flutter/material.dart';
import 'package:scan_doc/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatchDocs App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomeScreen(title: 'CatchDocs Home'),
    );
  }
}

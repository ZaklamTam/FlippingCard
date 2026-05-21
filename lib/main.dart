import 'package:flutter/material.dart';
import 'home_page.dart';

// main entry point
void main() {
  runApp(const MyApp());
}

// appli root class (canvas, stateless)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // set theme color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MyHomePage(title: 'Example'),
    );
  }
}

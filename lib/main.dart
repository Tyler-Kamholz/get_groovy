import 'package:flutter/material.dart';
import 'main_page.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Get Groovy',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: MainPage());
  }
}

import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Groovy'),
        backgroundColor: const Color(0xffC8963E),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Song 1'),
          ),
          ListTile(
            title: Text('Song 2'),
          ),
          ListTile(
            title: Text('Song 3'),
          ),
          ListTile(
            title: Text('Song 4'),
          ),
          ListTile(
            title: Text('Song 5'),
          ),
        ],
      ),
      backgroundColor: const Color(0xffE3C567),
    );
  }
}

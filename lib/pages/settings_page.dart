import 'package:flutter/material.dart';
import 'package:getgroovy/pages/home_page.dart';
import 'package:getgroovy/pages/post_page.dart';
import 'package:getgroovy/pages/profile_page.dart';
import 'package:getgroovy/pages/search_page.dart';
import 'package:getgroovy/pages/settings_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(
        controller: controller,
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            backToPage(context);
          },
          icon: const Icon(Icons.chevron_left),
          color: Colors.white,
        ),
      ),
      body: Text('Settings'),
    );
  }

  void backToPage(BuildContext context) {
    Navigator.pop(context);
  }
}

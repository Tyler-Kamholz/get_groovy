import 'package:flutter/material.dart';
import 'package:getgroovy/pages/home_page.dart';
import 'package:getgroovy/pages/notifications_page.dart';
import 'package:getgroovy/pages/post_page.dart';
import 'package:getgroovy/pages/profile_page.dart';
import 'package:getgroovy/pages/search_page.dart';
import 'package:getgroovy/pages/settings_page.dart';
import 'package:getgroovy/widgets/notification_builder.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              backToPage(context);
            },
            icon: const Icon(Icons.chevron_left),
          )),
      body: Snap(
        controller: controller.appBar,
        child: ListView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            return NotificationsBuilder.buildPostCard();
          },
        ),
      ),
    );
  }

  void backToPage(BuildContext context) {
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';
import 'package:getgroovy/widgets/notification_builder.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

import '../themes/theme_provider.dart';

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
      backgroundColor:
          Provider.of<ThemeProvider>(context).getCurrentTheme().backgroundColor,
      appBar: AppBar(
          backgroundColor:
              Provider.of<ThemeProvider>(context).getCurrentTheme().navBarColor,
          foregroundColor: Provider.of<ThemeProvider>(context)
              .getCurrentTheme()
              .textBoxTextColor,
          title: const Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              backToPage(context);
            },
            icon: const Icon(Icons.chevron_left),
            color:
                Provider.of<ThemeProvider>(context).getCurrentTheme().iconColor,
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

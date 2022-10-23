import 'package:flutter/material.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

import '../helpers/helpers.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = ScrollController();
  final textBoxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textBoxController,
        ),
      ),
      body: Snap(
        controller: controller.appBar,
        child: ListView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            return _buildUserSearch(textBoxController);
          },
        ),
      ),
    );
  }
}

Widget _buildUserSearch(TextEditingController textBox) {
  String userName = textBox.text;

  //this is trying to see if the textbox is empty and change it to whatever was typed
  //it does not currently work right now. kinda. It works if you type something in and
  //press save on the file so i assume it has to do something with set state or change
  //notifiers
  if (userName != "") {
    return Column(children: [
      ListTile(
        // Profile is a random color right now
        leading: CircleAvatar(
            backgroundColor: ColorHelper.random(),
            minRadius: 20,
            maxRadius: 20),
        // Text is a random username right now
        title: Text(userName),
        // Tapping on an entry navigates to their profile
      ),
      const Divider()
    ]);
  } else {
    return Column(children: [
      ListTile(
        // Profile is a random color right now
        leading: CircleAvatar(
            backgroundColor: ColorHelper.random(),
            minRadius: 20,
            maxRadius: 20),
        // Text is a random username right now
        title: const Text('User_Names'),
        // Tapping on an entry navigates to their profile
      ),
      const Divider()
    ]);
  }
}

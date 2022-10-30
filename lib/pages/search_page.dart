import 'package:flutter/material.dart';
import 'package:getgroovy/pages/profile_page.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:getgroovy/dummy_data.dart';
import '../helpers/helpers.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = ScrollController();
  TextEditingController textBoxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextField(
              controller: textBoxController,
              decoration: const InputDecoration(labelText: 'Search'),
            )),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 15,
            controller: controller,
            itemBuilder: (context, index) {
              return _buildUserSearch(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserSearch(BuildContext context) {
    String name = DummyData.getRandomName();
    Image image = DummyData.getRandomImage();

    return Column(children: [
      ListTile(
        // Profile is a random color right now
        leading: CircleAvatar(
            foregroundImage: image.image,
            backgroundColor: ColorHelper.random(),
            minRadius: 15,
            maxRadius: 15),
        // Text is a random username right now
        title: Text(name),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text(name),
                ),
                body: ProfilePage(userID: name)),
            fullscreenDialog: true,
          ));
        },
        // Tapping on an entry navigates to their profile
      ),
      const Divider()
    ]);
  }
}

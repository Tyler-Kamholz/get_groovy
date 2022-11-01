import 'package:flutter/material.dart';
import 'package:getgroovy/pages/profile_page.dart';
import 'package:getgroovy/dummy_data.dart';

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
            child: Stack(
              children: [
                TextField(
                  controller: textBoxController,
                  decoration: const InputDecoration(labelText: 'Search'),
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.qr_code_scanner))),
              ],
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
        leading: CircleAvatar(
            foregroundImage: image.image, minRadius: 15, maxRadius: 15),
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

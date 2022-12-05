import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/pages/profile_page.dart';
import 'package:getgroovy/dummy_data.dart';
import 'package:getgroovy/widgets/qr_reader.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = ScrollController();
  TextEditingController textBoxController = TextEditingController();

  Future<QuerySnapshot<Map<String, dynamic>>>? _usersListFuture;

  @override
  void initState() {
    _usersListFuture = FirebaseFirestore.instance.collection('users').get();
    super.initState();
  }

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
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const QRViewExample()));
                        },
                        icon: const Icon(Icons.qr_code_scanner))),
              ],
            )),
        Expanded(
          child: FutureBuilder(
            future: _usersListFuture,
            builder: (context, snapshot) {
              if(snapshot.hasData && snapshot.data != null) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return _buildUserSearchResult(
                      snapshot.data!.docs[index]['display_name'],
                      snapshot.data!.docs[index]['user_id']);
                  }
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserSearchResult(String name, String userID) {
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
                body: ProfilePage(userID: userID)),
            fullscreenDialog: true,
          ));
        },
        // Tapping on an entry navigates to their profile
      ),
      const Divider()
    ]);
  }
}

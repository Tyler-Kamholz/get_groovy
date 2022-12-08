import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/database_helpers.dart';
import 'package:getgroovy/spotify/spotify_provider.dart';
import 'package:getgroovy/widgets/post_card_builder.dart';
import 'package:provider/provider.dart';

import '../model/post.dart';
import '../themes/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = ScrollController();

  late Future<List<Post>> _future;

  @override
  void initState() {
    super.initState();

    _future =
        DatabaseHelpers.getFollowing(FirebaseAuth.instance.currentUser!.uid)
            .then((followingList) => FirebaseFirestore.instance
                    .collection('posts')
                    .withConverter<Post>(
                        fromFirestore: Post.fromJson, toFirestore: Post.toJson)
                    .get()
                    .then((value) {
                  List<Post> returnPosts = [];
                  for (var element in value.docs) {
                    if (followingList.contains(element.data().userID) ||
                        element.data().userID ==
                            FirebaseAuth.instance.currentUser!.uid) {
                      returnPosts.add(element.data());
                    }
                  }
                  returnPosts.sort(
                    (a, b) => b.time.compareTo(a.time),
                  );
                  return returnPosts;
                }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeProvider>(context).getCurrentTheme().backgroundColor,
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return PostCardWidget(
                  post: snapshot.data![index],
                  provider: Provider.of<SpotifyProvider>(context),
                );
              },
            );
          }
          return Container(
            width: 100,
            height: 100,
            color: Colors.transparent,
          );
        },
      ),
    );
  }
}

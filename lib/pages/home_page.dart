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

  late Future<QuerySnapshot<Post>> _future;

  @override
  void initState() {
    super.initState();

    _future = DatabaseHelpers.getFollowers(FirebaseAuth.instance.currentUser!.uid).then((followingList) => 
      FirebaseFirestore.instance
      .collection('posts')
      .where('user_id', whereIn: followingList)
      .withConverter<Post>(
        fromFirestore: Post.fromJson, 
        toFirestore: Post.toJson)
      .get()
    );
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
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return PostCardWidget(
                  post: snapshot.data!.docs[index].data(),
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

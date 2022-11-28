import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/widgets/post_card_builder.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = ScrollController();

  late Future<QuerySnapshot<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = FirebaseFirestore.instance.collection('posts').get();
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
                return PostCardBuilder.buildPostCard(
                    snapshot.data!.docs[index].data(), context);
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

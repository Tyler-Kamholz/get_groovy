import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getgroovy/dummy_data.dart';
import 'package:getgroovy/widgets/reaction_bar.dart';

import '../helpers/helpers.dart';
import '../pages/profile_page.dart';

class Song {
  String name;
  String artist;
  String imageURL;

  Song({required this.name, required this.artist, required this.imageURL});
}

class PostCardBuilder {
  static Card buildPostCard(BuildContext context) {
    Song song = DummyData.getRandomSong();
    String name = DummyData.getRandomName();
    Image image = DummyData.getRandomImage();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(song.imageURL)),
          ),
          Expanded(
            child: SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(song.artist),
                        Text('${Random().nextInt(24)} hours ago'),
                        Expanded(child: Container()),
                        const ReactionBar(),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
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
                        child: CircleAvatar(
                            foregroundImage: image.image,
                            backgroundColor: ColorHelper.random(),
                            minRadius: 15,
                            maxRadius: 15),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        padding: const EdgeInsets.all(0.0),
                        constraints: const BoxConstraints(),
                        iconSize: 28,
                        onPressed: () {},
                        icon: const Icon(Icons.playlist_add),
                        tooltip: 'Add to playlist',
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

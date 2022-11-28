import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getgroovy/spotify/spotify_provider.dart';
import 'package:getgroovy/widgets/reaction_bar.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/track.dart';

import '../helpers/helpers.dart';
import '../pages/profile_page.dart';
import '../themes/theme_provider.dart';

class Song {
  String name;
  String artist;
  String imageURL;

  Song({required this.name, required this.artist, required this.imageURL});
}

class PostCardBuilder {
  static Widget buildPostCard(
      Map<String, dynamic> postData, BuildContext context) {
    var provider = Provider.of<SpotifyProvider>(context);
    Future<ImageUri?>? imageFuture;
    Future<Track?> trackFuture =
        provider.getTrackFromID(postData['song_id']).then(
      (value) {
        imageFuture = provider.getAlbumCover(value!.album);
        return value;
      },
    );
    return FutureBuilder(
      future: trackFuture,
      builder: (context, snapshot) {
        return Card(
          color:
              Provider.of<ThemeProvider>(context).getCurrentTheme().cardColor,
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
                    child: () {
                      if (!snapshot.hasData) {
                        return Container(color: ColorHelper.random());
                      } else {
                        if (imageFuture != null) {
                          return FutureBuilder(
                            future: imageFuture!,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircleAvatar(
                                    child: CircularProgressIndicator());
                              } else {
                                return Image.network(snapshot.data!.raw);
                              }
                            },
                          );
                        } else {
                          return Container(color: ColorHelper.random());
                        }
                      }
                    }(),
                  )),
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
                              () {
                                if (snapshot.hasData) {
                                  return snapshot.data!.name;
                                } else {
                                  return '...';
                                }
                              }(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(() {
                              if (snapshot.hasData) {
                                return snapshot.data!.artist.name!;
                              } else {
                                return '...';
                              }
                            }()),
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
                                      title: const Text('name'),
                                    ),
                                    body: ProfilePage(
                                      userID: postData['user_id'],
                                    )),
                                fullscreenDialog: true,
                              ));
                            },
                            child: CircleAvatar(
                                //foregroundImage: image.image,
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
      },
    );

    /*
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
                                body: Container()),//const ProfilePage(user: null,)),
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
    */
  }
}

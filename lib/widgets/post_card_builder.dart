import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/database_helpers.dart';
import 'package:getgroovy/spotify/spotify_provider.dart';
import 'package:getgroovy/widgets/reaction_bar.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/track.dart';

import '../helpers/helpers.dart';
import '../model/post.dart';
import '../pages/profile_page.dart';
import '../themes/theme_provider.dart';

class Song {
  String name;
  String artist;
  String imageURL;

  Song({required this.name, required this.artist, required this.imageURL});
}

class PostCardWidget extends StatefulWidget {
  final Post post;
  final SpotifyProvider provider;

  const PostCardWidget({required this.post, required this.provider, super.key});
  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  Future<ImageUri?>? imageFuture;
  Future<Track?>? trackFuture;

  @override
  void initState() {
    super.initState();
    trackFuture = widget.provider.getTrackFromID(widget.post.songID).then(
      (value) {
        setState(() {
          imageFuture = widget.provider.getAlbumCover(value!.album);
        });
        return value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                              snapshot.hasData ? snapshot.data!.name : '...',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(snapshot.hasData
                                ? snapshot.data!.artist.name!
                                : '...'),
                            Text(getElapsedTimeString(widget.post.time)),
                            Expanded(child: Container()),
                            ReactionBar(postID: widget.post.postID,),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Scaffold(
                                    appBar: AppBar(
                                      backgroundColor:
                                          Provider.of<ThemeProvider>(context)
                                              .getCurrentTheme()
                                              .navBarColor,
                                      foregroundColor:
                                          Provider.of<ThemeProvider>(context)
                                              .getCurrentTheme()
                                              .textBoxTextColor,
                                      title: const Text('name'),
                                    ),
                                    body: ProfilePage(
                                      userID: widget.post.userID,
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
                          IconButton(
                            padding: const EdgeInsets.all(0.0),
                            constraints: const BoxConstraints(),
                            iconSize: 28,
                            onPressed: () {
                              widget.provider.playSong((widget.post.songID));
                            },
                            icon: const Icon(Icons.play_arrow),
                            tooltip: 'Play song',
                          ),
                          IconButton(
                            padding: const EdgeInsets.all(0.0),
                            constraints: const BoxConstraints(),
                            iconSize: 28,
                            onPressed: () {
                              DatabaseHelpers.getUserByID(userID: FirebaseAuth.instance.currentUser!.uid).then((user) {
                                if(user != null) {
                                  widget.provider.getTrackFromID(widget.post.songID).then((song) {
                                    if(song != null) {
                                      DatabaseHelpers.addActivity(userID: widget.post.userID, message: '${user.displayName} added your song "${song.name}"');
                                    }
                                  });
                                }
                              });
                              widget.provider.addSongToLibrary((widget.post.songID));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added song to liked songs!'),)
                              );
                            },
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
  }

  String getElapsedTimeString(Timestamp oldTime) {
    var duration = DateTime.now().difference(oldTime.toDate());
    if (duration.inDays > 0) {
      return '${duration.inDays} days ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minutes ago';
    } else {
      return '${duration.inSeconds} seconds ago';
    }
  }
}

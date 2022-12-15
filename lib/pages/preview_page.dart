/// Name: Matthew, Tyler, Dalton
/// Date: December 14, 2022
/// Description: This is a page that allows users to confirm that this is the track that they want to post. It 
/// includes a button they must click in order to confirm, and also shows the track they are going to post.
/// Bugs: N/A
/// Reflection: This is great for if the user does not know they have clicked the wrong track to the postPage. This
/// way the user knows exactly what they're posting.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/database_helpers.dart';
import 'package:getgroovy/spotify/spotify_provider.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/track.dart';

import '../themes/theme_provider.dart';

class PreviewPage extends StatefulWidget {
  final Track track;
  const PreviewPage({required this.track, super.key});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  Future<void>? _postFuture;

  double imageSize = 250;

  //matching the theme of the application this method creates the track and post button in order to confirm 
  //that this is what the user wants to post
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Provider.of<ThemeProvider>(context).getCurrentTheme().navBarColor,
        foregroundColor: Provider.of<ThemeProvider>(context)
            .getCurrentTheme()
            .textBoxTextColor,
        title: const Text('Confirm Post'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _postFuture == null
              ? Column(
                  children: [
                    SizedBox(
                        width: imageSize,
                        height: imageSize,
                        // This futureBuilder waits to load the album cover image
                        // It will either show the picture, a loading indicator,
                        // or an error message depending on what has happened
                        child: FutureBuilder(
                          future: Provider.of<SpotifyProvider>(context)
                              .getAlbumCover(widget.track.album),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (snapshot.hasData) {
                                if (snapshot.data != null) {
                                  return Image.network(snapshot.data!.raw);
                                } else {
                                  return const Text('null');
                                }
                              } else {
                                return const Text('Empty data');
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.track.name,
                        style: const TextStyle(fontSize: 32),
                      ),
                    )
                  ],
                )
              : FutureBuilder(
                  future: _postFuture,
                  builder: (context, snapshot) {
                    return const CircularProgressIndicator();
                  },
                ),
          // Disable the button if _postFuture is active so you can't double post.
          ElevatedButton(onPressed: _postFuture == null ? _post : null, child: const Text("POST"))
        ]),
      ),
    );
  }

  //This method uses the database helpers in order to put the post into the database so others can access it
  //confirm the post
  void _post() {
    // Grab ID data
    var songID =
        widget.track.uri.substring(widget.track.uri.lastIndexOf(':') + 1);
    var userID = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      // Set the current post future using database helper functions. If it succeeds, pop.
      // If anything fails, set the future back to null to allow for re-trying.
      _postFuture =
          DatabaseHelpers.addPost(songID: songID, userID: userID).then((_) {
        Navigator.of(context).pop();
      }).onError((error, stackTrace) {
        _postFuture = null;
      });
    });
  }
}

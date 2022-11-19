import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/track.dart';

import '../spotify/spotify_provider.dart';

/// A basic pair structure to hold a track and it's image
/// Must exist beacuse track.imageURI is unreliable
class _TrackImagePair {
  Track? track;
  ImageUri? image;
  _TrackImagePair({this.track, this.image});
}

class TrackFutureDisplay extends StatefulWidget {
  final Future<Track?> baseFuture;
  final SpotifyProvider provider;

  const TrackFutureDisplay({super.key, required this.baseFuture, required this.provider});

  @override
  State<TrackFutureDisplay> createState() => _TrackFutureDisplayState();
}

class _TrackFutureDisplayState extends State<TrackFutureDisplay> {
  late Future<_TrackImagePair> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.baseFuture.then((track) {
      if (track != null) {
        return widget.provider.getAlbumCover(track.album).then((image) {
          return _TrackImagePair(
            track: track,
            image: image,
          );
        });
      }
      return _TrackImagePair();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data!.image != null) {
                return SizedBox(
                  width: 150,
                  child: Column(
                    children: [
                      SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.network(snapshot.data!.image!.raw)),
                      Text(
                        snapshot.data!.track!.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              } else {
                return const Text('null');
              }
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        });
  }
}

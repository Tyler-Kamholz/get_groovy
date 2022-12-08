import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/track.dart';

import '../spotify/spotify_provider.dart';

class TrackImage extends StatefulWidget {
  final Track track;
  final SpotifyProvider provider;
  late final Future<ImageUri?> _future;

  TrackImage({super.key, required this.track, required this.provider}) {
    _future = provider.getAlbumCover(track.album);
  }

  @override
  State<TrackImage> createState() => _TrackImageState();
}

class _TrackImageState extends State<TrackImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget._future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return Image.network(snapshot.data!.raw);
          } else {
            return const Text("REPLACE WITH ERROR IMAGE");
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

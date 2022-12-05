import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/track.dart';

import '../spotify/spotify_provider.dart';

class TrackImage extends StatefulWidget {
  final Track track;
  final SpotifyProvider provider;

  const TrackImage(
      {super.key, required this.track, required this.provider});

  @override
  State<TrackImage> createState() => _TrackImageState();
}

class _TrackImageState extends State<TrackImage> {
  late Future<ImageUri?> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.provider.getAlbumCover(widget.track.album);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data != null) {
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

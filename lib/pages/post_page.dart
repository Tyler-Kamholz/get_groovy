import 'package:getgroovy/spotify/spotify_provider.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/pages/preview_page.dart';
import 'package:spotify_sdk/models/track.dart';

import '../widgets/clickable_container.dart';
import '../widgets/track_future_display.dart';

class PostPage extends StatefulWidget {
  final SpotifyProvider provider;

  const PostPage({required this.provider, super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with TickerProviderStateMixin {
  late AnimationController controller;

  int? selectedSongIndex;
  late Future<Track?> lastSongFuture;
  late Future<Track?> currentSongFuture;
  Track? track1;
  Track? track2;

  @override
  void initState() {
    super.initState();
    lastSongFuture = widget.provider.getLastSong().then((value) {
      setState(() {
        track1 = value;
      });
      return value;
    });
    currentSongFuture = widget.provider.getCurrentSong().then((value) {
      setState(() {
        track2 = value;
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClickableContainer(
                selected:
                    selectedSongIndex == null ? false : selectedSongIndex == 0,
                onTap: () {
                  if (track1 != null) {
                    setState(() {
                      selectedSongIndex = 0;
                    });
                  }
                },
                child: TrackFutureDisplay(
                    baseFuture: lastSongFuture, provider: widget.provider)),
            ClickableContainer(
                selected:
                    selectedSongIndex == null ? false : selectedSongIndex == 1,
                onTap: () {
                  if (track2 != null) {
                    setState(() {
                      selectedSongIndex = 1;
                    });
                  }
                },
                child: TrackFutureDisplay(
                    baseFuture: currentSongFuture, provider: widget.provider)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: _previewSong,
                  child: const Text("Preview Song")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: _addToPlaylist,
                  child: const Text("Add To Playlist")),
            ),
          ],
        )
      ],
    );
  }

  //Pushes preview in order to confirm the post
  void _previewSong() {
    if(selectedSongIndex != null) {
      Track? track = [track1, track2][selectedSongIndex!];
      if(track != null) {
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: false, builder: (context) => PreviewPage(track: track,)));
      }
    }
  }

  //add this song to a playlist
  void _addToPlaylist() {

  }
}

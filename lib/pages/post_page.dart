import 'package:getgroovy/spotify/spotify_provider.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/pages/preview_page.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/track.dart';

import '../widgets/clickable_container.dart';
import '../widgets/track_future_display.dart';

class PostPage extends StatefulWidget {
  SpotifyProvider provider;

  PostPage({required this.provider, super.key});

  @override
  State<PostPage> createState() => _PostPageState(provider);
}

class _PostPageState extends State<PostPage> with TickerProviderStateMixin {
  late AnimationController controller;

  int? selectedSongIndex;
  late Future<Track?> lastSongFuture;
  late Future<Track?> currentSongFuture;
  Track? track1;
  Track? track2;

  _PostPageState(SpotifyProvider provider) {
    lastSongFuture = provider.getLastSong().then((value) {
      setState(() {
        track1 = value;
      });
      return value;
    });
    currentSongFuture = provider.getCurrentSong().then((value) {
      setState(() {
        track2 = value;
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SpotifyProvider provider =
        Provider.of<SpotifyProvider>(context, listen: false);

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

  //Plays preview of song
  void _playSong() {}

  //add this song to a playlist
  void _addToPlaylist() {}

  //pauses the preview of the song
  void _pauseSong() {}
}

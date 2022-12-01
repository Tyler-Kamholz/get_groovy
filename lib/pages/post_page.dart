import 'package:getgroovy/spotify/spotify_provider.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/pages/preview_page.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/track.dart';

import '../themes/theme_provider.dart';
import '../widgets/clickable_container.dart';
import '../widgets/track_future_display.dart';

class PostPage extends StatefulWidget {
  final SpotifyProvider provider;

  const PostPage({required this.provider, super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

enum SelectedSongType {
  none,
  current,
  previous
}

class _PostPageState extends State<PostPage> with TickerProviderStateMixin {
  late AnimationController controller;

  SelectedSongType _selectedSongType = SelectedSongType.none;
  late Future<Track?> _lastSongFuture;
  late Future<Track?> _currentSongFuture;
  Track? selectedTrack;

  @override
  void initState() {
    super.initState();
    _lastSongFuture = widget.provider.getLastSong();
    _currentSongFuture = widget.provider.getCurrentSong();
  }

  Widget buildSelectableSong(Future<Track?> future, SelectedSongType highlightOn) {
    return SizedBox(
                  width: 175,
                  child: FutureBuilder(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          return ClickableContainer(
                              selected: _selectedSongType == highlightOn,
                              onTap: () {
                                setState(() {
                                  _selectedSongType = highlightOn;
                                  selectedTrack = snapshot.data;
                                });
                              },
                              child: Column(
                                children: [
                                  TrackImage(
                                      track: snapshot.data!,
                                      provider: widget.provider),
                                  Text(snapshot.data!.name,
                                  overflow: TextOverflow.ellipsis,)
                                ],
                              ));
                        } else {
                          return Container();
                        }
                      } else {
                        return const AspectRatio(
                          aspectRatio: 1.0,
                          child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Provider.of<ThemeProvider>(context)
            .getCurrentTheme()
            .backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: Future.wait([_lastSongFuture, _currentSongFuture]),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  if(snapshot.data != null) {
                    var len = snapshot.data!.length;
                    int numSongs = 0;
                    for(int i = 0; i < len; i++) {
                      if(snapshot.data![numSongs] != null) {
                        numSongs++;
                      }
                    }
                    if(snapshot.data!.isEmpty || numSongs == 0) {
                      return const Text("Couldn't find any songs.");
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildSelectableSong(_lastSongFuture, SelectedSongType.previous),
                          buildSelectableSong(_currentSongFuture, SelectedSongType.current),
                        ],
                      );
                    }
                  } else {
                    return const Text("Couldn't find any songs.");
                  }
                } else {
                  return const SizedBox(width: 150, height: 150, child: CircularProgressIndicator());
                }
              },),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed:
                          _selectedSongType != SelectedSongType.none ? _previewPost : null,
                      child: const Text("Preview Post")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed:
                          _selectedSongType != SelectedSongType.none ? _addToPlaylist : null,
                      child: const Text("Add To Playlist")),
                ),
              ],
            )
          ],
        ));
  }

  //Pushes preview in order to confirm the post
  void _previewPost() {
    if (_selectedSongType != SelectedSongType.none) {
      if (selectedTrack != null) {
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: false,
            builder: (context) => PreviewPage(
                  track: selectedTrack!,
                )));
      }
    }
  }

  //add this song to a playlist
  void _addToPlaylist() {}
}

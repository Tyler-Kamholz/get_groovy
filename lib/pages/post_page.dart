import 'package:flutter/material.dart';
import 'package:getgroovy/pages/preview_page.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with TickerProviderStateMixin {
  late AnimationController controller;
  @override
  Widget build(BuildContext context) {
    //scrub bar controller
    controller = controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    //constant imageSize
    const double imageSize = 250;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              width: imageSize,
              height: imageSize,
              image: Image.asset('images/AlbumCover.png').image),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Song Name",
              style: TextStyle(fontSize: 32),
            ),
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              //contains a play, pause, and scrub
              children: [
                IconButton(
                    onPressed: _playSong, icon: const Icon(Icons.play_arrow)),
                IconButton(
                    onPressed: _pauseSong, icon: const Icon(Icons.pause)),
                SizedBox(
                    width: 300,
                    height: 3,
                    child: LinearProgressIndicator(
                      value: controller.value,
                      semanticsLabel: 'Linear progress indicator',
                    )),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _previewSong, child: const Text("Preview Song")),
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
      ),
    );
  }

  //Pushes preview in order to confirm the post
  void _previewSong() {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: false, builder: (context) => const PreviewPage()));
  }

  //Plays preview of song
  void _playSong() {}

  //add this song to a playlist
  void _addToPlaylist() {}

  //pauses the preview of the song
  void _pauseSong() {}
}

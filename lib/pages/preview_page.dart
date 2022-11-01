import 'package:flutter/material.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  double imageSize = 250;
  @override
  Widget build(BuildContext context) {
    //scrub bar controller
    controller = controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Post'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              //contains a play, pause, and scrub
              children: [
                IconButton(
                    onPressed: _playSong, icon: const Icon(Icons.play_arrow)),
                IconButton(
                    onPressed: _pauseSong, icon: const Icon(Icons.pause)),
                Expanded(
                  child: SizedBox(
                      height: 3,
                      child: LinearProgressIndicator(
                        value: controller.value,
                        semanticsLabel: 'Linear progress indicator',
                      )),
                ),
              ]),
        ),
        ElevatedButton(onPressed: _post, child: const Text("POST"))
      ]),
    );
  }

  //play preview of the song
  void _playSong() {}

  //pauses the preview of the song
  void _pauseSong() {}

  //confirm the post
  void _post() {}
}

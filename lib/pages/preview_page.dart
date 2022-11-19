import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/spotify/spotify_provider.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/track.dart';

class PreviewPage extends StatefulWidget {
  final Track track;
  const PreviewPage({required this.track, super.key});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage>
    with TickerProviderStateMixin {
  double imageSize = 250;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Post'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: FutureBuilder(
              future: Provider.of<SpotifyProvider>(context)
                  .getAlbumCover(widget.track.album),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.track.name,
              style: const TextStyle(fontSize: 32),
            ),
          ),
          ElevatedButton(onPressed: _post, child: const Text("POST"))
        ]),
      ),
    );
  }

  //confirm the post
  void _post() {
    var id = widget.track.uri.substring(widget.track.uri.lastIndexOf(':') + 1);
    FirebaseFirestore.instance.collection('posts').add(
      {
        'user_id': FirebaseAuth.instance.currentUser!.uid,
        'song_id': id,
        'time': Timestamp(0, 0),
      }
    );
  }
}

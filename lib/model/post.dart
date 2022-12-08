import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String songID;
  String userID;
  String postID;
  Timestamp time;

  Post({required this.songID, required this.userID, required this.time, required this.postID});

  static Post fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    var data = snapshot.data();
    return Post(
      songID: data!['song_id'], 
      time: data['time'], 
      userID: data['user_id'],
      postID: data['post_id']
    );
  }

  static Map<String, Object?> toJson(Post post, SetOptions? options) {
    return {
      'time': post.time,
      'song_id': post.songID,
      'user_id': post.userID,
      'post_id': post.postID
    };
  }
}
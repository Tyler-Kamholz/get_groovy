import 'package:cloud_firestore/cloud_firestore.dart';

/*
 *Name: Matthew
 *Date: December 14, 2022
 *Description: In post_reaction.dart, it handles the emoji
               badge reactions associated with each post.  
 *Bugs: N/A
 *Reflection: The emoji provides an outlet for interctions between users.
*/
class PostReaction {
  String emoji;
  String userID;

  PostReaction({required this.emoji, required this.userID});

  /// Converts json to a PostReaction
  static PostReaction fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    var data = snapshot.data();
    return PostReaction(
      emoji: data!['emoji'],
      userID: data['user_id'],
    );
  }

  /// Converts a PostReaction to json
  static Map<String, Object?> toJson(
      PostReaction reaction, SetOptions? options) {
    return {
      'user_id': reaction.userID,
      'emoji': reaction.emoji,
    };
  }

  /// Returns a map of <emoji, count>
  static Map<String, int> organizeEmojiCounts(List<PostReaction> reactionList) {
    Map<String, int> map = {};
    for (var element in reactionList) {
      map[element.emoji] = (map[element.emoji] ?? 0) + 1;
    }
    return map;
  }
}

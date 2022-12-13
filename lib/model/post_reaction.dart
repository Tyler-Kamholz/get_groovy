/// Name: Matthew
/// Date: January 13, 2022
/// Bugs: N/A
/// Reflection: Basic model for reactions

import 'package:cloud_firestore/cloud_firestore.dart';

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

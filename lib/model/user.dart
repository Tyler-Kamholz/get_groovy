/// Name: Matthew
/// Date: January 13, 2022
/// Bugs: N/A
/// Reflection: Basic model for users

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String displayName;
  String email;
  String userID;
  String? imageID;

  User(
      {required this.displayName,
      required this.email,
      required this.userID,
      this.imageID});

  /// Converts json to a PostReaction
  static User fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    var data = snapshot.data();
    return User(
        displayName: data!['display_name'],
        email: data['email'],
        userID: data['user_id'],
        imageID: data['image_id']);
  }

  /// Converts a PostReaction to json
  static Map<String, Object?> toJson(User user, SetOptions? options) {
    return {
      'display_name': user.displayName,
      'email': user.email,
      'user_id': user.userID,
      'image_id': user.imageID
    };
  }
}

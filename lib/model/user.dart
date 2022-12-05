import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String displayName;
  String email;
  String userID;

  User({required this.displayName, required this.email, required this.userID});

  static User fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    var data = snapshot.data();
    return User(
      displayName: data!['display_name'],
      email: data['email'],
      userID: data['user_id'],
    );
  }

  static Map<String, Object?> toJson(User user, SetOptions? options) {
    return {
      'display_name': user.displayName,
      'email': user.email,
      'user_id': user.userID
    };
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/post.dart';

class DatabaseHelpers {
  static Future<bool> isXFollowingY(String userIdX, String userIdY) async {
    var followingCollection = await FirebaseFirestore.instance
        .collection('users')
        .doc(userIdX)
        .collection('following')
        .get();
    var docs = followingCollection.docs;
    for (int i = 0; i < docs.length; i++) {
      if (docs[i].id == userIdY) {
        return true;
      }
    }
    return false;
  }

  static Future<void> follow(
      {required String follower, required String following}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(follower)
        .collection('following')
        .doc(following)
        .set({}, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection('users')
        .doc(following)
        .collection('followers')
        .doc(follower)
        .set({}, SetOptions(merge: true));
  }

  static Future<void> unfollow(
      {required String follower, required String following}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(follower)
        .collection('following')
        .doc(following)
        .delete();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(following)
        .collection('followers')
        .doc(follower)
        .delete();
  }

  static Future<List<String>> getFollowers(String userID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('followers')
        .get();
    return List.generate(
        snapshot.docs.length, (index) => snapshot.docs[index].id);
  }

  static Future<List<String>> getFollowing(String userID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('following')
        .get();
    return List.generate(
        snapshot.docs.length, (index) => snapshot.docs[index].id);
  }

  static Future<List<Post>> getPosts(String userID) async {
    var result = await FirebaseFirestore.instance
        .collection('posts')
        .withConverter<Post>(
            fromFirestore: Post.fromJson, toFirestore: Post.toJson)
        .where('user_id', isEqualTo: userID)
        .get();
    return List.generate(result.docs.length, (index) => result.docs[index].data());
  }
}

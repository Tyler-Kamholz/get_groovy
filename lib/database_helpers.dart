import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getgroovy/model/post_reaction.dart';

import 'model/post.dart';
import 'model/user.dart';

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
    return List.generate(
        result.docs.length, (index) => result.docs[index].data());
  }

  static Future<List<User>> getAllUsers() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .withConverter<User>(
            fromFirestore: User.fromJson, toFirestore: User.toJson)
        .get();
    return List.generate(
      result.docs.length, (index) => result.docs[index].data());
  }

  static Future<void> addPost({required String songID, required String userID}) {
    return FirebaseFirestore.instance
      .collection('posts')
      .add({}) // First, add an empty object so we can get the ID of the object
      .then((value) {
        return FirebaseFirestore.instance
          .collection('posts')
          .doc(value.id) 
          .set({ // Now, update that same object with the real post data.
            'user_id': userID,
            'song_id': songID,
            'time': Timestamp.now(),
            'post_id': value.id
          });
    },);
  }

  static Future<List<PostReaction>> getReactions({required String postID}) async {
    var result = await FirebaseFirestore.instance
      .collection('posts')
      .doc(postID)
      .collection('reactions')
      .withConverter<PostReaction>(
              fromFirestore: PostReaction.fromJson, toFirestore: PostReaction.toJson)
      .get();
    return List.generate(
      result.docs.length, (index) => result.docs[index].data());
  }

  static Future<void> addReaction({required String postID, required PostReaction reaction}) {
    return FirebaseFirestore.instance
      .collection('posts')
      .doc(postID)
      .collection('reactions')
      .doc(reaction.userID)
      .set(PostReaction.toJson(reaction, null));
  }

  static Future<void> deleteReaction({required String postID, required String userID}) {
    return FirebaseFirestore.instance
      .collection('posts')
      .doc(postID)
      .collection('reactions')
      .doc(userID)
      .delete();
  }
}

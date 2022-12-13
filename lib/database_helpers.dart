/// Name: Matthew
/// Date: January 13, 2022
/// Bugs: N/A
/// Reflection: N/A

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getgroovy/model/post_reaction.dart';

import 'model/post.dart';
import 'model/user.dart';

class DatabaseHelpers {
  
  // Checks if user X is following user Y
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

  // Makes <follower> follow the <following> account
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
    var user = await DatabaseHelpers.getUserByID(userID: follower);
    if(user != null) {
      DatabaseHelpers.addActivity(userID: following, message: '${user.displayName} is now following you!');
    }
  }

  // Makes <follower> unfollow <following> account
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

  // Gets all the followers for the user
  static Future<List<String>> getFollowers(String userID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('followers')
        .get();
    return List.generate(
        snapshot.docs.length, (index) => snapshot.docs[index].id);
  }

  // Gets all the people who this user is following
  static Future<List<String>> getFollowing(String userID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('following')
        .get();
    return List.generate(
        snapshot.docs.length, (index) => snapshot.docs[index].id);
  }

  // Gets all the posts of this user
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

  // Gets a list of all users
  static Future<List<User>> getAllUsers() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .withConverter<User>(
            fromFirestore: User.fromJson, toFirestore: User.toJson)
        .get();
    return List.generate(
      result.docs.length, (index) => result.docs[index].data());
  }

  // Adds a post to the database
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

  // Gets reactions from a post
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

  // Adds a reaction to a post
  static Future<void> addReaction({required String postID, required PostReaction reaction}) {
    return FirebaseFirestore.instance
      .collection('posts')
      .doc(postID)
      .collection('reactions')
      .doc(reaction.userID)
      .set(PostReaction.toJson(reaction, null));
  }

  // Deletes a reaction from a post
  static Future<void> deleteReaction({required String postID, required String userID}) {
    return FirebaseFirestore.instance
      .collection('posts')
      .doc(postID)
      .collection('reactions')
      .doc(userID)
      .delete();
  }

  // Gets a user by their ID
  static Future<User?> getUserByID({required String userID}) async {
      var result = await FirebaseFirestore.instance
        .collection('users')
        .withConverter<User>(
            fromFirestore: User.fromJson, toFirestore: User.toJson)
        .doc(userID)
        .get();
      return result.data();
  }

  // Gets a post by it's ID
  static Future<Post?> getPostByID({required String postID}) async {
      var result = await FirebaseFirestore.instance
        .collection('posts')
        .withConverter<Post>(
            fromFirestore: Post.fromJson, toFirestore: Post.toJson)
        .doc(postID)
        .get();
      return result.data();
  }

  // Adds an activity
  static void addActivity({required String userID, required String message}) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('activity')
      .add({
        'message': message,      
      });
  }

  // Gets all of the activity associated with a user from the database.
  static Future<List<String>> getActivities({required String userID}) async {
    var result = await FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('activity')
      .get();
    return List.generate(
      result.docs.length, 
      (index) => result.docs[index].data()['message']);
  }
}

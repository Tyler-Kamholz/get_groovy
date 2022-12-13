import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'model/post.dart';
import 'model/user.dart' as modelUser;
import 'package:path/path.dart';

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

  static Future<List<modelUser.User>> getAllUsers() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .withConverter<modelUser.User>(
            fromFirestore: modelUser.User.fromJson,
            toFirestore: modelUser.User.toJson)
        .get();
    return List.generate(
        result.docs.length, (index) => result.docs[index].data());
  }

  static Future<void> updateProfilePicture(File file) async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    String fileName = basename(file.path);

    await FirebaseStorage.instance
        .ref()
        .child("$userID/$fileName")
        .putFile(file);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .set({'image_id': fileName}, SetOptions(merge: true));
  }

  static Future<String?> getProfilePictureURL(String userID) async {
    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .withConverter<modelUser.User>(
            fromFirestore: modelUser.User.fromJson,
            toFirestore: modelUser.User.toJson)
        .get();
    if (userSnapshot.data() == null || userSnapshot.data()!.imageID == null) {
      return null;
    }
    var child = FirebaseStorage.instance
        .ref()
        .child("$userID/${userSnapshot.data()!.imageID}");
    return child.getDownloadURL();
  }
}

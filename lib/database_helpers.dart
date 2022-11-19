import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelpers {
  static Future<bool> isXFollowingY(String userIdX, String userIdY) async {
    var followingCollection = await FirebaseFirestore.instance.collection('users').doc(userIdX).collection('following').get();
    var docs = followingCollection.docs;
    for(int i = 0; i < docs.length; i++) {
      if(docs[i]['user_id'] == userIdY) {
        return true;
      }
    }
    return false;
  }
}
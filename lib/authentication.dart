/// Name: Kaia, Matthew
/// Date: January 13, 2022
/// Bugs: N/A
/// Reflection: N/A

import 'package:firebase_auth/firebase_auth.dart';

/// Signs the user in
Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return true; 
  } catch (e) {
      return false;
  }
}

// Registers the user
Future<bool> register(String email, String password) async{
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return true; 
  }
  on FirebaseAuthException {
    return false; 
  }
  catch (e) {
    return false; 
  }
  
}
    
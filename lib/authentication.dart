/*
 *Name: Kaia, Matthew
 *Date: December 14, 2022
 *Description: Provides tools for authentication
 *Bugs: N/A
 *Reflection: Kaia create 1st attempt Futures signIn and register. 
              Matthew helped make it more precise and correctly 
              save into Firebase Authentication. 
*/

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
    
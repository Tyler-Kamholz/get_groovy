import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return true; 
  } catch (e) {
      return false;
  }
}

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
    
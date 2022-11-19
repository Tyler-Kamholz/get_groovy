import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
     print("success");
    return true; 
  } catch (e) {
      print(e);
      return false;
  }
}

Future<bool> register(String email, String password) async{
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    print("success");
    return true; 
  }
  on FirebaseAuthException catch (e) {
    print(e.toString()); 
    return false; 
  }
  catch (e) {
    print(e.toString()); 
    return false; 
  }
  
}
    
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /* Future createAccount(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential.user);
      return (userCredential.user?.uid);
    } on FirebaseAuthException catch (e) {
      // Weak Password
      if (e.code == 'weak-password') {
        print('The password provided is too weak');
        return 1;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email');
        return 2;
      }
    } catch (e) {
      print(e);
    }
  } */

  Future singInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final userId = userCredential.user;

      if (userId?.uid != null) {
        return userId?.uid;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 1;
      } else if (e.code == 'wrong-password') {
        return 2;
      }
    } catch (e) {
      print(e);
    }
  }
}

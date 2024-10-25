import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instance of AuthService & Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      // Sign in user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data in firestore if it doesn't already exist
      DocumentSnapshot userDoc = await _firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        _firestore.collection("Users").doc(userCredential.user!.uid).set(
          {
            "uid": userCredential.user!.uid,
            "email": email,
          },
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      // Create user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data in firestore
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          "uid": userCredential.user!.uid,
          "email": email,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}

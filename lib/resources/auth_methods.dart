import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SIGNUP
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    String alert = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        //add user to the database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'bio': username,
          'followers': [],
          'following': [],
          'profile_picture': file,
        });
        alert = "succes";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        //do something if email is invalid
      } else if (err.code == 'weak-password') {
        //do something if password too weak (pass below  6 letters)
      }
      //etc
    } catch (err) {
      alert = err.toString();
    }
    return alert;
  }

  //login
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'succes';
      } else {
        res = "Please enter the empty field";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = "User doesn't exist";
      } else if (err.code == 'wrong-password') {
        res = "Wrong password";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //signout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      fireStore
          .collection("users")
          .doc(userCredential.user!.uid)
          .collection("account")
          .doc(userCredential.user!.email)
          .set({
        "uid": userCredential.user!.uid,
        "email": userCredential.user!.email,
      }, SetOptions(merge: true));
      // fireStore.collection("alluser").doc(email).set({
      //   "user": email,
      //   "imageLink":
      //       "https://i.pinimg.com/1200x/6d/26/e2/6d26e264e3c11ec2c8c9025c91279ba1.jpg",
      // });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential?> signUpWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      fireStore
          .collection("users")
          .doc(userCredential.user!.uid)
          .collection("account")
          .doc(userCredential.user!.email)
          .set({
        "uid": userCredential.user!.uid,
        "email": userCredential.user!.email,
        "imageLink":
            "https://i.pinimg.com/1200x/6d/26/e2/6d26e264e3c11ec2c8c9025c91279ba1.jpg"
      });
      fireStore.collection("alluser").doc(email).set({
        "user": email,
        "imageLink":
            "https://i.pinimg.com/1200x/6d/26/e2/6d26e264e3c11ec2c8c9025c91279ba1.jpg",
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }
}

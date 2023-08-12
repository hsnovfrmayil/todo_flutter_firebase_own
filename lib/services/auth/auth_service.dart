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
      fireStore.collection("alluser").doc(email).set({
        "user": email,
      });
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
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }

  Future<String> messageAdd(String message, String searchController) async {
    final Stream<QuerySnapshot> users =
        fireStore.collection("alluser").snapshots();
    StreamBuilder(
      stream: users,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("loading");
        }
        final data = snapshot.requireData;
        for (int i = 0; i < data.docs.length; i++) {
          if (data.docs[i]['user'].toString().contains(searchController)) {
            fireStore
                .collection("chatapp")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection(data.docs[i]['user'])
                .doc(data.docs[i]['user'])
                .set({
              "message": message,
            });
            print("done");
          }
        }
        return Text("hello");
      },
    );
    return "hell";
  }
}

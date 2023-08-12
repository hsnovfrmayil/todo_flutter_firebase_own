import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_statement/model/todo_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ToDoService extends ChangeNotifier {
  final todoCollection = FirebaseFirestore.instance.collection("todoApp");
  final users = FirebaseFirestore.instance.collection("users");

  void addNewTask(String docID, ToDoModel model) {
    // todoCollection.doc(docID).set(model.toMap());
    users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("todoapp")
        .doc(docID)
        .set(model.toMap());
  }

  void updateTask(String? docID, bool? valueUpdate) {
    users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("todoapp")
        .doc(docID)
        .update({
      'isDone': valueUpdate,
    });
  }

  void deleteTask(String? docID) {
    users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("todoapp")
        .doc(docID)
        .delete();
  }
}

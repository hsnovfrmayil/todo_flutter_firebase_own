import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_statement/model/todo_model.dart';
import 'package:data_statement/services/todo_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceProvider = StateProvider<ToDoService>(
  (ref) {
    return ToDoService();
  },
);

final fetchStreamProvider = StreamProvider<List<ToDoModel>>(
  (ref) async* {
    final getData = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("todoapp")
        .snapshots()
        .map((event) => event.docs
            .map((snapshot) => ToDoModel.fromSnapshot(snapshot))
            .toList());
    yield* getData;
  },
);

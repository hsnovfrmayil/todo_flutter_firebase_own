import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final firebase_storage = FirebaseStorage.instance;
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);
    try {
      await firebase_storage.ref('test/$fileName').putFile(file);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future listFiles() async {
    final results = await firebase_storage.ref("test").listAll();

    results.items.forEach((Reference ref) {
      print("Found file: $ref");
    });
    return results;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL =
        await firebase_storage.ref("test/$imageName").getDownloadURL();
    return downloadURL;
  }
}

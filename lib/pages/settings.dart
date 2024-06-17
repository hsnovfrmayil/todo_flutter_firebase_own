import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/image_service.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final Storage storage = Storage();
  final fireStore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> imageLink = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("account")
      .snapshots();
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("todoapp")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 100),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          StreamBuilder(
                            stream: imageLink,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Icon(Icons.person);
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Icon(Icons.person);
                              }
                              return snapshot.requireData.docs[0]
                                          ['imageLink'] !=
                                      null
                                  ? Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: ClipOval(
                                        child: Image.network(
                                          snapshot.requireData.docs[0]
                                              ['imageLink'],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.person);
                            },
                          ),
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: IconButton(
                              onPressed: () async {
                                final result =
                                    await FilePicker.platform.pickFiles(
                                  allowMultiple: false,
                                  type: FileType.custom,
                                  allowedExtensions: ['png', 'jpg'],
                                );
                                if (result == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("No file selected")));
                                  return null;
                                }
                                final path = result.files.single.path!;
                                final fileName = result.files.single.name;
                                // print(path);
                                // print(fileName);
                                storage
                                    .uploadFile(path, fileName)
                                    .then((value) => print("Done"));
                                final downloadLink =
                                    await storage.downloadURL(fileName);
                                print(downloadLink);
                                fireStore
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("account")
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .set({
                                  "imageLink": downloadLink,
                                }, SetOptions(merge: true));
                                fireStore
                                    .collection("alluser")
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .update({
                                  "imageLink": downloadLink,
                                });
                                print(FirebaseAuth.instance.currentUser!.email);
                              },
                              icon: const Icon(
                                Icons.add_a_photo,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: ListTile(
                      title: StreamBuilder(
                        stream: imageLink,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text("user");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("user");
                          }
                          return Text(
                            snapshot.requireData.docs[0]['email'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              GestureDoneDedector(
                title: "Done",
                icon: CupertinoIcons.person,
                subtitle: "Only Done ToDoApp",
                imageLink:
                    "https://www.nicepng.com/png/detail/18-184908_discord-emoticon-happy-smiley-face-emoji.png",
                func: () {},
              ),
              SizedBox(
                height: 20,
              ),
              GestureDoneDedector(
                title: "Not Done",
                icon: CupertinoIcons.person,
                subtitle: "Only Not Done ToDoApp",
                imageLink:
                    "https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTEwL3JtNTg2LWZyb3duaW5nZmFjZS0wMV8xLWw5ZDNjMXYwLnBuZw.png",
                func: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GestureDoneDedector extends StatelessWidget {
  GestureDoneDedector({
    super.key,
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.imageLink,
    required this.func,
  });
  final String title;
  final IconData icon;
  final String subtitle;
  final String imageLink;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          leading: Icon(icon),
          trailing: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            child: ClipOval(
              child: Image.network(
                imageLink,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

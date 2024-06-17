import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_statement/pages/image_show_page.dart';
import 'package:data_statement/services/image_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatPage extends ConsumerWidget {
  ChatPage({
    super.key,
    required this.who,
    required this.user,
    required this.imageUrl,
    required this.whoImageUrl,
  });
  final String who;
  final String user;
  final String imageUrl;
  final String whoImageUrl;
  final messageController = TextEditingController();
  final Stream<QuerySnapshot> imageLink = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("account")
      .snapshots();
  final storage = Storage();
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Stream<QuerySnapshot> messages = FirebaseFirestore.instance
        .collection("chat")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(user)
        .orderBy("timestamp", descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(user),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.44,
              child: StreamBuilder(
                stream: messages,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("");
                  }
                  final data = snapshot.requireData;
                  List<QueryDocumentSnapshot> reversedMessages =
                      data.docs.toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: reversedMessages.length,
                    itemBuilder: (context, index) {
                      if (reversedMessages[index]['value'] == '1' ||
                          reversedMessages[index]['value'] == '3') {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: ListTile(
                                  leading: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: ClipOval(
                                      child: StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection("alluser")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.email)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          }

                                          if (!snapshot.hasData ||
                                              snapshot.data == null) {
                                            return Text('Veri tapilmadi');
                                          }

                                          var data = snapshot.data!.data();
                                          var imageLink = data?['imageLink'];

                                          if (imageLink == null) {
                                            return Text('Image Link tapilmadi');
                                          }
                                          // print(imageLink);
                                          return Image.network(
                                            imageLink,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  title: reversedMessages[index]['value'] == '1'
                                      ? Text(
                                          reversedMessages[index]['message'],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageShowPage(
                                                          imageUrl:
                                                              reversedMessages[
                                                                      index]
                                                                  ['message'],
                                                        )));
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 70,
                                            child: Image.network(
                                              reversedMessages[index]
                                                  ['message'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  subtitle: Text(
                                    DateFormat('HH:mm').format(reversedMessages[
                                            index]['timestamp']
                                        .toDate()), // Saati belirli bir biçimde göster
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: ListTile(
                                  leading: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: ClipOval(
                                      child: StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection("alluser")
                                            .doc(user)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          }

                                          if (!snapshot.hasData ||
                                              snapshot.data == null) {
                                            return Text('Veri tapilmadi');
                                          }

                                          var data = snapshot.data!.data();
                                          var imageLink = data?['imageLink'];

                                          if (imageLink == null) {
                                            return Text('Image Link tapilmadi');
                                          }
                                          // print(imageLink);
                                          return Image.network(
                                            imageLink,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  title: reversedMessages[index]['value'] == '2'
                                      ? Text(
                                          reversedMessages[index]['message'],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageShowPage(
                                                          imageUrl:
                                                              reversedMessages[
                                                                      index]
                                                                  ['message'],
                                                        )));
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 70,
                                            child: Image.network(
                                              reversedMessages[index]
                                                  ['message'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  subtitle: Text(
                                    DateFormat('HH:mm').format(reversedMessages[
                                            index]['timestamp']
                                        .toDate()), // Saati belirli bir biçimde göster
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Positioned(
              bottom: 70,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 10,
                              child: TextField(
                                controller: messageController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter message..."),
                              ),
                            ),
                            Expanded(
                              flex: 1,
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
                                  await FirebaseFirestore.instance
                                      .collection("chat")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .collection(user)
                                      .add({
                                    "message": downloadLink,
                                    "value": "3",
                                    "timestamp": Timestamp.now(),
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("chat")
                                      .doc(user)
                                      .collection(FirebaseAuth
                                          .instance.currentUser!.email
                                          .toString())
                                      .add({
                                    "message": downloadLink,
                                    "value": "4",
                                    "timestamp": Timestamp.now(),
                                  });

                                  print(
                                      FirebaseAuth.instance.currentUser!.email);
                                },
                                icon: Icon(Icons.image),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("chat")
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection(user)
                              .add({
                            "message": messageController.text,
                            "value": "1",
                            "timestamp": Timestamp.now(),
                          });
                          await FirebaseFirestore.instance
                              .collection("chat")
                              .doc(user)
                              .collection(FirebaseAuth
                                  .instance.currentUser!.email
                                  .toString())
                              .add({
                            "message": messageController.text,
                            "value": "2",
                            "timestamp": Timestamp.now(),
                          });
                          messageController.clear();
                          print("done");
                        },
                        child: Text("Send"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

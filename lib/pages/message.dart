import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_statement/pages/chat_page.dart';
import 'package:data_statement/provider/profile_image_provider.dart';
import 'package:data_statement/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagePage extends ConsumerWidget {
  MessagePage({super.key});
  final searchController = TextEditingController();
  final authService = AuthService();
  final firesStore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> alluser =
      FirebaseFirestore.instance.collection("alluser").snapshots();
  final Stream<QuerySnapshot> imageLink = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("account")
      .snapshots();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Message",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Search",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              StreamBuilder(
                stream: alluser,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("");
                  }
                  final data = snapshot.requireData;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      return data.docs[index]['user'] !=
                              FirebaseAuth.instance.currentUser!.email
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      who: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      user: data.docs[index]['user'],
                                      imageUrl: data.docs[index]['imageLink'],
                                      whoImageUrl: data.docs[index]['user'] ==
                                              FirebaseAuth
                                                  .instance.currentUser!.email
                                          ? data.docs[index]['imageLink']
                                          : "https://i.pinimg.com/1200x/6d/26/e2/6d26e264e3c11ec2c8c9025c91279ba1.jpg",
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  title: Text(data.docs[index]['user']),
                                ),
                              ),
                            )
                          : const Text("");
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

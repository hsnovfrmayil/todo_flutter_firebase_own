import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_statement/model/message_model.dart';
import 'package:data_statement/provider/message_provider.dart';
import 'package:data_statement/provider/who_state.dart';
import 'package:data_statement/services/auth/auth_service.dart';
import 'package:data_statement/widgets/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagePage extends ConsumerWidget {
  MessagePage({super.key});
  final searchController = TextEditingController();
  final authService = AuthService();
  final firesStore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> alluser =
      FirebaseFirestore.instance.collection("users").snapshots();
  final String who = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Message> message = ref.watch(messageProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Message",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        authService.messageAdd("hel", searchController.text);
                      },
                      child: Text(
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
                  return Text("");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("");
                }
                final data = snapshot.requireData;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(data.docs[index]['user']),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

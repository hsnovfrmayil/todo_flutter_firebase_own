import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../provider/service_provider.dart';

class ExtraPage extends ConsumerWidget {
  ExtraPage({super.key});
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("todoapp")
      .snapshots();
  final categoryColor = Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
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

              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: categoryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            width: 20,
                          ),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: IconButton(
                                    icon: Icon(CupertinoIcons.delete),
                                    onPressed: () {
                                      ref.read(serviceProvider).deleteTask(
                                          data.docs[index]['docID']);
                                    },
                                  ),
                                  title: Text(
                                    data.docs[index]['titleTask'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        decoration: data.docs[index]['isDone']
                                            ? TextDecoration.lineThrough
                                            : null),
                                  ),
                                  subtitle: Text(
                                    data.docs[index]['description'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        decoration: data.docs[index]['isDone']
                                            ? TextDecoration.lineThrough
                                            : null),
                                  ),
                                  trailing: Transform.scale(
                                    scale: 1.5,
                                    child: Checkbox(
                                        activeColor: Colors.blue.shade800,
                                        shape: CircleBorder(),
                                        value: data.docs[index]['isDone'],
                                        onChanged: (value) {
                                          ref.read(serviceProvider).updateTask(
                                              "${data.docs[index]['docID']}",
                                              !data.docs[index]['isDone']);
                                          print(data.docs[index]['docID']);
                                        }),
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(0, -12),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Divider(
                                          thickness: 1.5,
                                          color: Colors.grey.shade100,
                                        ),
                                        Row(
                                          children: [
                                            Text("Today"),
                                            Gap(12),
                                            Text(data.docs[index]['timeTask']),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

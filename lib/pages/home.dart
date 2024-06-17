import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_statement/pages/message.dart';
import 'package:data_statement/pages/settings.dart';
import 'package:data_statement/provider/service_provider.dart';
import 'package:data_statement/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../common/show_model.dart';
import '../services/image_service.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});
  final authService = AuthService();
  final user = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("todoapp")
      .snapshots();
  final Stream<QuerySnapshot> imageLink = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("account")
      .snapshots();
  Color categoryColor = Colors.white;
  final Storage storage = Storage();
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(fetchStreamProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.amber.shade200,
            radius: 25,
            child: StreamBuilder(
              stream: imageLink,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.person,
                      size: 10,
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.person,
                      size: 10,
                    ),
                  );
                }

                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100)),
                  child: ClipOval(
                    child: Image.network(
                      snapshot.requireData.docs[0]['imageLink'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          title: Text(
            'Hello I\'m',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
          subtitle: Text(
            user!.email.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                  icon: const Icon(
                    CupertinoIcons.settings,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.bell,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MessagePage()));
                  },
                  icon: const Icon(
                    CupertinoIcons.memories,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    authService.signOut();
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
            children: [
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today\'s Task",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Wednesday, 11 May",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD5E8FA),
                      foregroundColor: Colors.blue.shade800,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => showModalBottomSheet(
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        context: context,
                        builder: (context) => AddNewTaskModel()),
                    child: Text(
                      "+ New Task",
                    ),
                  ),
                ],
              ),
              Gap(20),
              // ListView.builder(
              //   itemCount: todoData.value?.length ?? 0,
              //   shrinkWrap: true,
              //   itemBuilder: (context, index) {
              //     return CartToDoWidget(
              //       getIndex: index,
              //     );
              //   },
              // ),
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

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      final getCategory = data.docs[index]['category'];
                      switch (getCategory) {
                        case "Learning":
                          categoryColor = Colors.green;
                          break;
                        case "Working":
                          categoryColor = Colors.blue.shade700;
                          break;
                        case "General":
                          categoryColor = Colors.amber.shade700;
                          break;
                      }
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
                                            decoration: data.docs[index]
                                                    ['isDone']
                                                ? TextDecoration.lineThrough
                                                : null),
                                      ),
                                      subtitle: Text(
                                        data.docs[index]['description'],
                                        maxLines: 1,
                                        style: TextStyle(
                                            decoration: data.docs[index]
                                                    ['isDone']
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
                                                Text(data.docs[index]
                                                    ['timeTask']),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

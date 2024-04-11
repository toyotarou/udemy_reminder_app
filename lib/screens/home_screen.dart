import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_udemy_reminder_app/extensions/extensions.dart';
import 'package:test_udemy_reminder_app/models/reminder.dart';

import '../general/general.dart';
import 'remind_input_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remind Me'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text('reminders'),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(sharedPreferences!.getString('uid')).collection('reminders').snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: SizedBox(
                        height: context.screenSize.height * 0.7,
                        width: context.screenSize.width,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final model = Reminder.fromJson(snapshot.data!.docs[index].data()! as Map<String, dynamic>);
                            return Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(3, 3),
                                    blurRadius: 15,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(model.reminderTitle!),
                                      Text(model.reminderDescription!),
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance.collection('reminders').doc(model.reminderId).delete().whenComplete(() {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(sharedPreferences!.getString('uid'))
                                              .collection('reminders')
                                              .doc(model.reminderId)
                                              .delete()
                                              .whenComplete(() {
                                            Fluttertoast.showToast(msg: 'Reminder deleted succccesfully!');
                                          });
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const RemindInputScreen(), fullscreenDialog: true));
        },
        label: const Icon(Icons.add_rounded),
      ),
    );
  }
}

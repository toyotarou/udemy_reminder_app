import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                      child: Container(
                        height: context.screenSize.height * 0.7,
                        width: context.screenSize.width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final model = Reminder.fromJson(snapshot.data!.docs[index].data()! as Map<String, dynamic>);
                            return Text(model.reminderTitle!);
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

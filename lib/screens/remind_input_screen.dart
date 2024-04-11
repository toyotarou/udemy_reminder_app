import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_udemy_reminder_app/general/general.dart';

import '../extensions/extensions.dart';

class RemindInputScreen extends StatefulWidget {
  const RemindInputScreen({super.key});

  @override
  State<RemindInputScreen> createState() => _RemindInputScreenState();
}

class _RemindInputScreenState extends State<RemindInputScreen> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool isLoading = false;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Reminder'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('title'),
              CupertinoTextField(
                controller: titleEditingController,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(225, 225, 225, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 50),
              const Text('description'),
              CupertinoTextField(
                maxLines: 10,
                controller: descriptionEditingController,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(225, 225, 225, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: selectDate,
                    child: Text((selectedDate != null) ? selectedDate!.yyyymmdd : 'date'),
                  ),
                  TextButton(
                    onPressed: selectTime,
                    child: Text((selectedTime != null) ? '${selectedTime!.hour}:${selectedTime!.minute}' : 'time'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (titleEditingController.text.trim().isNotEmpty && descriptionEditingController.text.trim().isNotEmpty) {
                          if (selectedTime != null && selectedTime != null) {
                            setState(() {
                              isLoading = true;
                            });

                            final reminderId =
                                DateTime.now().millisecondsSinceEpoch.toString() + sharedPreferences!.getString('uid')!.substring(0, 3);

                            final finalDateTime =
                                DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute);

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(sharedPreferences!.getString('uid'))
                                .collection('reminders')
                                .doc(reminderId)
                                .set({
                              'reminderId': reminderId,
                              'reminderCreatedDate': DateTime.now().millisecondsSinceEpoch,
                              'reminderTitle': titleEditingController.text,
                              'reminderDescription': descriptionEditingController.text,
                              'reminderDate': finalDateTime,
                              'status': 'created',
                              'userId': sharedPreferences!.getString('uid')
                            }).whenComplete(() {
                              FirebaseFirestore.instance.collection('reminders').doc(reminderId).set({
                                'reminderId': reminderId,
                                'reminderCreatedDate': DateTime.now().millisecondsSinceEpoch,
                                'reminderTitle': titleEditingController.text,
                                'reminderDescription': descriptionEditingController.text,
                                'reminderDate': finalDateTime,
                                'status': 'created',
                                'userId': sharedPreferences!.getString('uid')
                              }).whenComplete(() {
                                setState(() {
                                  isLoading = false;
                                  titleEditingController.clear();
                                  descriptionEditingController.clear();
                                  selectedDate = null;
                                  selectedTime = null;

                                  Fluttertoast.showToast(msg: 'reminder registed', timeInSecForIosWeb: 5);
                                });
                              });
                            });
                          } else {
                            await Fluttertoast.showToast(msg: 'date and time are required');
                          }
                        } else {
                          await Fluttertoast.showToast(msg: 'title and description are required');
                        }
                      },
                      child: const Text('add reminder'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  ///
  Future<void> selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      selectedTime = pickedTime;
    }
  }
}

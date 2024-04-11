import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  Reminder({this.reminderCreatedDate, this.reminderDate, this.reminderDescription, this.reminderId, this.reminderTitle, this.status, this.userID});

  Reminder.fromJson(Map<String, dynamic> json) {
    reminderCreatedDate = json['reminderCreatedDate'];
    reminderDate = json['reminderDate'];
    reminderDescription = json['reminderDescription'];
    reminderId = json['reminderId'];
    reminderTitle = json['reminderTitle'];
    status = json['status'];
    userID = json['userID'];
  }

  Reminder.toJson() {
    final data = <String, dynamic>{};

    data['reminderCreatedDate'] = reminderCreatedDate;
    data['reminderDate'] = reminderDate;
    data['reminderDescription'] = reminderDescription;
    data['reminderId'] = reminderId;
    data['reminderTitle'] = reminderTitle;
    data['status'] = status;
    data['userID'] = userID;
  }

  int? reminderCreatedDate;
  Timestamp? reminderDate;
  String? reminderDescription;
  String? reminderId;
  String? reminderTitle;
  String? status;
  String? userID;
}

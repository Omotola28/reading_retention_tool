import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationData {
  static const String idField = 'id';
  static const String notificationIdField = 'notificationId';
  static const String notificationIdStringField = 'notificationIdString';
  static const String titleField = 'title';
  static const String descriptionField = 'description';
  static const String hourField = 'hour';
  static const String minuteField = 'minute';
 // static const String dayField = 'day';

  String id;
  int notificationId;
  String notificationIdString;
  String title;
  String description;
  //int day;
  int hour;
  int minute;

  NotificationData(this.title, this.notificationIdString, this.description, this.hour, this.minute);

  NotificationData.fromDb(Map<String, dynamic> json, String id) {
    this.id = id;
    this.notificationId = json[notificationIdField];
    this.notificationIdString = json[notificationIdStringField];
    this.title = json[titleField];
    this.description = json[descriptionField];
    this.hour = json[hourField];
    this.minute = json[minuteField];
  }

  Map<String, dynamic> toJson() {
    return {
      notificationIdField: this.notificationId,
      notificationIdStringField: this.notificationIdString,
      titleField: this.title,
      descriptionField: this.description,
      hourField: this.hour,
      minuteField: this.minute,
    };
  }

  @override
  String toString() {
    return 'title: $title, notificationId: $notificationIdString, description: $description, hour: $hour, minute: $minute';
  }
}
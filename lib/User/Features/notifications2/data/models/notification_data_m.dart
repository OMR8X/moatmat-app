import 'package:moatmat_app/User/Features/notifications2/domain/entities/notifications_data.dart';

class NotificationDataModel extends NotificationData {
  NotificationDataModel({
    required super.id,
    required super.title,
    required super.content,
    required super.date,
  });
  factory NotificationDataModel.fromJson(Map json) {
    return NotificationDataModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      date: DateTime.parse(json["date"]),
    );
  }
  factory NotificationDataModel.fromClass(NotificationData notificationData) {
    return NotificationDataModel(
      id: notificationData.id,
      title: notificationData.title,
      content: notificationData.content,
      date: notificationData.date,
    );
  }
  toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "date": date.toString(),
    };
  }
}

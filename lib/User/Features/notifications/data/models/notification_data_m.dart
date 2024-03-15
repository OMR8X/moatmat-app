import 'package:moatmat_app/User/Features/notifications/domain/entities/notifications_data.dart';

class NotificationDataModel extends NotificationData {
  NotificationDataModel({
    required super.id,
    required super.title,
    required super.content,
    required super.date,
  });
  factory NotificationDataModel.fromJson(Map json) {
    return NotificationDataModel(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      date: DateTime.parse(json["date"]),
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

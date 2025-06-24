import 'package:firebase_messaging/firebase_messaging.dart';

class AppNotification {
  final int id;
  final String title;
  final String? body;
  final String? html;
  final String? imageUrl;
  final DateTime date;
  final bool seen;

  bool isValid() {
    return title.isNotEmpty;
  }

  AppNotification copyWith({
    int? id,
    String? title,
    String? body,
    String? html,
    String? imageUrl,
    DateTime? date,
    bool? seen,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      html: html ?? this.html,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      seen: seen ?? this.seen,
    );
  }

  factory AppNotification.fromRemoteMessage(RemoteMessage message) {
    DateTime date = DateTime.now();
    if (message.data["date"] != null) {
      date = DateTime.parse(message.data["date"]);
    }
    return AppNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: message.data["title"] ?? '',
      body: message.data["body"],
      html: message.data["html"],
      imageUrl: message.data["image_url"],
      date: date,
    );
  }
  factory AppNotification.empty() {
    return AppNotification(
      id: 0,
      title: '',
      body: '',
      html: '',
      imageUrl: "",
      date: DateTime.now(),
    );
  }

  AppNotification({
    required this.id,
    required this.title,
    this.body,
    this.html,
    this.imageUrl,
    this.seen = false,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'html': html,
      'date': date.toIso8601String(),
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: 1,
      title: json['title'] ?? '',
      body: json['body'],
      html: json['html'],
      imageUrl: json['image_url'],
      seen: json['seen'] ?? false,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }
}

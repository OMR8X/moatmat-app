import 'package:firebase_messaging/firebase_messaging.dart';

class AppNotification {
  final String id;
  final String title;
  final String? body;
  final String? html;
  final String? imageUrl;
  final DateTime date;
  final bool seen;
  final Map<String, dynamic>? data; 

  bool isValid() {
    return title.isNotEmpty;
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? html,
    String? imageUrl,
    DateTime? date,
    bool? seen,
    Map<String, dynamic>? data, 
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      html: html ?? this.html,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      seen: seen ?? this.seen,
      data: data ?? this.data,
    );
  }

  factory AppNotification.fromRemoteMessage(RemoteMessage message) {
    DateTime date = DateTime.now();
    if (message.data["date"] != null) {
      date = DateTime.parse(message.data["date"]);
    }

    return AppNotification(
      id: message.data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.data["title"] ?? '',
      body: message.data["body"],
      html: message.data["html"],
      imageUrl: message.data["image_url"],
      date: date,
      data: Map<String, dynamic>.from(message.data), 
    );
  }

  factory AppNotification.empty() {
    return AppNotification(
      id: '',
      title: '',
      body: '',
      html: '',
      imageUrl: "",
      date: DateTime.now(),
      data: null,
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
    this.data, 
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'html': html,
      'date': date.toIso8601String(),
      'data': data, 
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] ?? '',
      body: json['body'],
      html: json['html'],
      imageUrl: json['image_url'],
      seen: json['seen'] ?? false,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      data: json['data'] is Map ? Map<String, dynamic>.from(json['data']) : null, 
    );
  }
}
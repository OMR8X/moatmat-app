import 'package:moatmat_app/User/Features/notifications/data/models/app_notification_model.dart';
import 'package:moatmat_app/User/Features/notifications/domain/entities/app_notification.dart';

extension AppNotificationModelMapper on AppNotificationModel {
  AppNotification get toEntity {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      html: html,
      date: date,
      imageUrl: imageUrl,
      seen: seen,
      data: data,
    );
  }
}

extension AppNotificationMapper on AppNotification {
  AppNotificationModel get toModel {
    return AppNotificationModel(
      id: id,
      title: title,
      body: body,
      html: html,
      date: date,
      imageUrl: imageUrl,
      seen: seen,
      data: data,
    );
  }
}
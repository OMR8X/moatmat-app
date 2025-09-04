import 'package:moatmat_app/Features/notifications/domain/entities/app_notification.dart';

class SendNotificationToTopicsRequest {
  AppNotification notification;
  List<String> topics;
  SendNotificationToTopicsRequest({
    required this.notification,
    required this.topics,
  });
}

import 'package:moatmat_app/Features/notifications/domain/entities/app_notification.dart';

class SendNotificationToUsersRequest {
  AppNotification notification;
  List<String> userIds;
  SendNotificationToUsersRequest({
    required this.notification,
    required this.userIds,
  });
}

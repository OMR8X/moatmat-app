import '../entities/notifications_data.dart';
import '../repository/repository.dart';

class IsThereNewNotificationsUC {
  final NotificationsRepository repository;

  IsThereNewNotificationsUC({required this.repository});
  bool call(List<NotificationData> notifications) {
    return repository.isThereNewNotifications(notifications);
  }
}

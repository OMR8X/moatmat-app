import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/notifications/domain/repository/repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entities/notifications_data.dart';

class ReadNotificationsUC {
  final NotificationsRepository repository;

  ReadNotificationsUC({required this.repository});
  void call(List<NotificationData> notification) async {
    return repository.readNotifications(notification);
  }
}

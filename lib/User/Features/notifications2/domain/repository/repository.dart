import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/notifications/domain/entities/notifications_data.dart';

abstract class NotificationsRepository {
  //
  Future<Either<Failure, List<NotificationData>>> getNotifications();
  //
  bool isThereNewNotifications(List<NotificationData> notifications);
  //
  void readNotifications(List<NotificationData> notifications);
}

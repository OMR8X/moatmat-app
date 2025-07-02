import 'package:dartz/dartz.dart';

import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import '../entities/app_notification.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUsecase {
  final NotificationsRepository repository;

  GetNotificationsUsecase({required this.repository});

  Future<Either<Failure, List<AppNotification>>> call() async {
    return await repository.getNotifications();
  }
}

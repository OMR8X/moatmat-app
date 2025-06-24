import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/notifications2/domain/repository/repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entities/notifications_data.dart';

class GetNotificationsUC {
  final NotificationsRepository repository;

  GetNotificationsUC({required this.repository});
  Future<Either<Failure, List<NotificationData>>> call() async {
    return repository.getNotifications();
  }
}

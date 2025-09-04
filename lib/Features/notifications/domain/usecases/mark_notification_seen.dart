import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import '../repositories/notifications_repository.dart';

class MarkNotificationSeen {
  final NotificationsRepository repository;

  MarkNotificationSeen({required this.repository});

  Future<Either<Failure, Unit>> call(String notificationId) async {
    return await repository.markNotificationAsSeen(notificationId);
  }
}

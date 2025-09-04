import 'package:dartz/dartz.dart';

import 'package:moatmat_app/Core/errors/export_errors.dart';
import '../repositories/notifications_repository.dart';

class InitializeLocalNotificationsUsecase {
  final NotificationsRepository repository;

  InitializeLocalNotificationsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.initializeLocalNotification();
  }
}

import 'package:dartz/dartz.dart';

import 'package:moatmat_app/Core/errors/export_errors.dart';
import '../repositories/notifications_repository.dart';

class InitializeFirebaseNotificationsUsecase {
  final NotificationsRepository repository;

  InitializeFirebaseNotificationsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.initializeFirebaseNotification();
  }
}

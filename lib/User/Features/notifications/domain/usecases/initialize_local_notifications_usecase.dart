import 'package:dartz/dartz.dart';

import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import '../repositories/notifications_repository.dart';

class InitializeLocalNotificationsUsecase {
  final NotificationsRepository repository;

  InitializeLocalNotificationsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.initializeLocalNotification();
  }
}

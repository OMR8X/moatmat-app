import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/notifications/domain/repositories/notifications_repository.dart';

class DeleteDeviceTokenUsecase {
  final NotificationsRepository repository;

  DeleteDeviceTokenUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.deleteDeviceToken();
  }
}

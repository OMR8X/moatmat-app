import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/notifications/domain/repositories/notifications_repository.dart';

class DeleteDeviceTokenUsecase {
  final NotificationsRepository repository;

  DeleteDeviceTokenUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.deleteDeviceToken();
  }
}

import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/notifications/domain/repositories/notifications_repository.dart';
import 'package:moatmat_app/Features/notifications/domain/requests/register_device_token_request.dart';

class RegisterDeviceTokenUseCase {
  final NotificationsRepository repository;

  RegisterDeviceTokenUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(RegisterDeviceTokenRequest request) async {
    return await repository.registerDeviceToken(
      deviceToken: request.deviceToken,
      platform: request.platform,
    );
  }
}

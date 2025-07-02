import 'package:dartz/dartz.dart';

import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import '../repositories/notifications_repository.dart';

class SubscribeToTopicUsecase {
  final NotificationsRepository repository;

  SubscribeToTopicUsecase({required this.repository});
  Future<Either<Failure, Unit>> call({required String topic}) async {
    return await repository.subscribeToTopic(topic: topic);
  }
}

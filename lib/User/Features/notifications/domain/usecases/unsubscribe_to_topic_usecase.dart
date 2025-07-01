import 'package:dartz/dartz.dart';

import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import '../repositories/notifications_repository.dart';

class UnsubscribeToTopicUsecase {
  final NotificationsRepository repository;

  UnsubscribeToTopicUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({required String topic}) async {
    return await repository.unsubscribeToTopic(topic: topic);
  }
}

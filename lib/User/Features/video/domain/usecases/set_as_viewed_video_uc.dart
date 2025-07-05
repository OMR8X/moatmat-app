import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/video/domain/repository/video_repository.dart';

class SetAsViewedVideoUc {
  final VideoRepository repository;

  SetAsViewedVideoUc({required this.repository});

  Future<Either<Failure, Unit>> call({
    required int videoId,
  }) async {
    return await repository.setAsViewedVideo(
      videoId: videoId,
    );
  }
}

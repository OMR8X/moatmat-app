import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/video.dart';
import 'package:moatmat_app/User/Features/video/domain/repository/video_repository.dart';

class GetVideoUc {
  final VideoRepository repository;

  GetVideoUc({required this.repository});

  Future<Either<Failure, Video>> call({
    required int videoId,
  }) async {
    return await repository.getVideo(
      videoId: videoId,
    );
  }
}

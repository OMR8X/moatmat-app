import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/video/domain/entites/video.dart';
import 'package:moatmat_app/Features/video/domain/repository/video_repository.dart';

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

import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/video/domain/entites/rating.dart';
import 'package:moatmat_app/Features/video/domain/repository/video_repository.dart';

class GetRatingUc {
  final VideoRepository repository;

  GetRatingUc({required this.repository});

  Future<Either<Failure, List<Rating>>> call({
    required int videoId,
  }) async {
    return await repository.getRatings(
      videoId: videoId,
    );
  }
}

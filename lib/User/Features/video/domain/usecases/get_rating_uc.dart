import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/rating.dart';
import 'package:moatmat_app/User/Features/video/domain/repository/video_repository.dart';

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

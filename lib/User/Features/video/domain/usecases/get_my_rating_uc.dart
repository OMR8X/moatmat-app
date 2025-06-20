import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/rating.dart';
import 'package:moatmat_app/User/Features/video/domain/repository/video_repository.dart';

class GetMyRatingUc {
  final VideoRepository repository;

  GetMyRatingUc({required this.repository});

  Future<Either<Failure, Rating>> call({
    required String userId,
    required int videoId,
  }) async {
    return await repository.getMyRatingOnVideo(
      userId: userId,
      videoId: videoId,
    );
  }
}

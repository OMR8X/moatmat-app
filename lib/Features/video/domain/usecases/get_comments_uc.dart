import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/video/domain/entites/comment.dart';
import 'package:moatmat_app/Features/video/domain/repository/video_repository.dart';

class GetCommentsUc {
  final VideoRepository repository;

  GetCommentsUc({required this.repository});

  Future<Either<Failure, List<Comment>>> call({
    required int videoId,
  }) async {
    return await repository.getComments(
      videoId: videoId,
    );
  }
}

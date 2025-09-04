import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/video/domain/entites/comment.dart';
import 'package:moatmat_app/Features/video/domain/repository/video_repository.dart';

class AddCommentUc {
  final VideoRepository repository;

  AddCommentUc({required this.repository});

  Future<Either<Failure, Unit>> call({
    required Comment comment,
  }) async {
    return await repository.addComments(
      comment: comment,
    );
  }
}

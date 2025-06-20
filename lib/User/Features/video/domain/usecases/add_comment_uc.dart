import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/comment.dart';
import 'package:moatmat_app/User/Features/video/domain/repository/video_repository.dart';

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

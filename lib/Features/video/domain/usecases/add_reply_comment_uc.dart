import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/video/domain/entites/reply_comment.dart';
import 'package:moatmat_app/Features/video/domain/repository/video_repository.dart';

class AddReplyCommentUc {
  final VideoRepository repository;

  AddReplyCommentUc({required this.repository});

  Future<Either<Failure, Unit>> call({
    required ReplyComment replyComment,
  }) async {
    return await repository.addReplyComments(
      replyComment: replyComment,
    );
  }
}

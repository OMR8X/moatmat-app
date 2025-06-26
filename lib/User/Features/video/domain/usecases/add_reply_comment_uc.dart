import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/reply_comment.dart';
import 'package:moatmat_app/User/Features/video/domain/repository/video_repository.dart';

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

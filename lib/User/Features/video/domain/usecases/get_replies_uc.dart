import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/reply_comment.dart';
import 'package:moatmat_app/User/Features/video/domain/repository/video_repository.dart';

class GetRepliesUc {
  final VideoRepository repository;

  GetRepliesUc({required this.repository});

  Future<Either<Failure, List<ReplyComment>>> call({
    required int commentId,
  }) async {
    return await repository.getReplyComments(
      commentId: commentId,
    );
  }
}

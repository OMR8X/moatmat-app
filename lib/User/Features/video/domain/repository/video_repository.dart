import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/comment.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/rating.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/reply_comment.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/video.dart';

abstract class VideoRepository {
  //
  Future<Either<Failure, Video>> getVideo({required int videoId});
  //
  Future<Either<Failure, List<Comment>>> getComments({required int videoId});
  //
  Future<Either<Failure, List<ReplyComment>>> getReplyComments({required int commentId});
  //
  Future<Either<Failure, List<Rating>>> getRatings({required int videoId});
  //
  Future<Either<Failure, Rating>> getMyRatingOnVideo({required int videoId, required String userId});
  //
  Future<Either<Failure, Unit>> addComments({required Comment comment});
  //
  Future<Either<Failure, Unit>> addReplyComments({required ReplyComment replyComment});
  //
  Future<Either<Failure, Unit>> addRaing({required Rating rating});
  //
  Future<Either<Failure, Unit>> setAsViewedVideo({required int videoId,required String userId});
  //
  Future<Either<Failure, Unit>> addVideo({required Video video});
  //

  // not working right now
  // Future<Either<Failure, Unit>> addLikeOnComment(int commentId);
  //
  // Future<Either<Failure, Unit>> addLikeOnReplyComment(int replyCommentId);
  //
}

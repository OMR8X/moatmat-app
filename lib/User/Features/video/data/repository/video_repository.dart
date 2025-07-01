import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Core/functions/handle_exception.dart';
import 'package:moatmat_app/User/Features/video/data/datasources/remote_data_source.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/comment.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/rating.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/reply_comment.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/video.dart';
import 'package:moatmat_app/User/Features/video/domain/repository/video_repository.dart';

class VideoRepositoryImpl extends VideoRepository {
  final VideoRemoteDataSource dataSource;

  VideoRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Unit>> addComments({
    required Comment comment,
  }) async {
    try {
      var res = await dataSource.addComments(comment: comment);
      return right(res);
    } on Exception catch (e) {
      return left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> addRaing({
    required Rating rating,
  }) async {
    try {
      var res = await dataSource.addRaing(rating: rating);
      return right(res);
    } on Exception catch (e) {
      return left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> addReplyComments({
    required ReplyComment replyComment,
  }) async {
    try {
      var res = await dataSource.addReplyComments(replyComment: replyComment);
      return right(res);
    } on Exception catch (e) {
      return left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Video>> getVideo({
    required int videoId,
  }) async {
    try {
      var res = await dataSource.getVideo(videoId: videoId);
      return right(res);
    } on Exception catch (e) {
      return left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getComments({
    required int videoId,
  }) async {
    try {
      var res = await dataSource.getComments(videoId: videoId);
      return right(res);
    } on Exception catch (e) {
      return left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Rating>>> getRatings({
    required int videoId,
  }) async {
    try {
      var res = await dataSource.getRatings(videoId: videoId);
      return right(res);
    } on Exception catch (e) {
      return left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<ReplyComment>>> getReplyComments({
    required int commentId,
  }) async {
    try {
      var res = await dataSource.getReplyComments(commentId: commentId);
      return right(res);
    } on Exception catch (e) {
      return left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Rating>> getMyRatingOnVideo({
    required int videoId,
    required String userId,
  }) async {
    try {
      var res = await dataSource.getMyRatingOnVideo(videoId: videoId, userId: userId);
      return right(res);
    } on Exception catch (e) {
      return left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> setAsViewedVideo({
    required int videoId,
    required String userId,
  }) async {
    try {
      var res = await dataSource.setAsViewedVideo(videoId: videoId, userId: userId);
      return right(res);
    } on Exception catch (e) {
      return left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> addVideo({
    required Video video,
  }) async {
    try {
      var res = await dataSource.addVideo(video: video);
      return right(res);
    } on Exception catch (e) {
      return left(handleException(e));
    }
  }
}

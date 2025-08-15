import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:moatmat_app/User/Features/video/data/models/comment_m.dart';
import 'package:moatmat_app/User/Features/video/data/models/rating_m.dart';
import 'package:moatmat_app/User/Features/video/data/models/reply_comment_m.dart';
import 'package:moatmat_app/User/Features/video/data/models/video_m.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/comment.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/rating.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/reply_comment.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/video.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class VideoRemoteDataSource {
  Future<Video> getVideo({
    required int videoId,
  });
  //
  Future<List<Comment>> getComments({
    required int videoId,
  });
  //
  Future<List<Rating>> getRatings({
    required int videoId,
  });
  //
  Future<List<ReplyComment>> getReplyComments({
    required int commentId,
  });
  //
  Future<Rating> getMyRatingOnVideo({
    required String userId,
    required int videoId,
  });
  //
  Future<Unit> addComments({
    required Comment comment,
  });
  //
  Future<Unit> addReplyComments({
    required ReplyComment replyComment,
  });
  //
  Future<Unit> addRaing({
    required Rating rating,
  });
  //
  Future<int> addVideo({
    required Video video,
  });
  //
  Future<Unit> setAsViewedVideo({
    required int videoId,
  });
}

class VideoRemoteDataSourceImpl extends VideoRemoteDataSource {
  final SupabaseClient client;

  VideoRemoteDataSourceImpl({required this.client});

  @override
  Future<Unit> addComments({
    required Comment comment,
  }) async {
    Map commentJson = CommentModel.fromClass(comment).toJson();
    //
    try {
      debugPrint("commentJson : $commentJson");
      await client.from("comment").insert(commentJson);
    } on PostgrestException catch (e) {
      debugPrint("PostgrestException: ${e.message}, code: ${e.code}, details: ${e.details}");
    } on Exception catch (e) {
      debugPrint("getting exception while uploading comment : ${e.toString()}");
    }

    //
    return unit;
  }

  @override
  Future<Unit> addRaing({
    required Rating rating,
  }) async {
    Map ratingJson = RatingModel.fromClass(rating).toJson();
    //
    try {
      await client.from("rating").insert(ratingJson);
    } on Exception {
      debugPrint("getting exception while uploading rating");
    }
    //
    return unit;
  }

  @override
  Future<Unit> addReplyComments({
    required ReplyComment replyComment,
  }) async {
    Map replyCommentJson = ReplyCommentModel.fromClass(replyComment).toJson();
    //
    try {
      await client.from("comment_reply").insert(replyCommentJson);
    } on Exception {
      debugPrint("getting exception while uploading rating");
    }
    //
    return unit;
  }

  @override
  Future<Video> getVideo({
    required int videoId,
  }) async {
    //
    try {
      var res = await setAsViewedVideo(videoId: videoId);
      debugPrint('res : $res');
    } catch (e) {
      debugPrint('error msg : ${e.toString()}');
    }
    //
    var res = await client.from('videos').select().eq("id", videoId).limit(1);
    //
    Video video = res
        .map(
          (e) => VideoModel.fromJson(e),
        )
        .toList()
        .first;
    //
    return video;
  }

  @override
  Future<List<Comment>> getComments({
    required int videoId,
  }) async {
    //
    var res = await client.from('get_comment_view').select().eq('video_id', videoId);
    //
    List<Comment> comments = res
        .map(
          (e) => CommentModel.fromJson(e),
        )
        .toList();
    //
    return comments;
  }

  @override
  Future<Rating> getMyRatingOnVideo({
    required String userId,
    required int videoId,
  }) async {
    //
    var res = await client.from('get_rating_view').select().eq('video_id', videoId).eq('user_id', userId);
    //
    if (res.isEmpty) {
      return Rating(
        id: -1,
        comment: '',
        username: '',
        rating: -1,
        videoId: videoId,
        userId: userId,
        createdAt: "",
      );
    }
    //
    Rating rating = res
        .map(
          (e) => RatingModel.fromJson(e),
        )
        .toList()
        .first;
    //
    return rating;
  }

  @override
  Future<List<Rating>> getRatings({
    required int videoId,
  }) async {
    //
    var res = await client.from('get_rating_view').select().eq('video_id', videoId);
    //
    List<Rating> ratings = res
        .map(
          (e) => RatingModel.fromJson(e),
        )
        .toList();
    //
    return ratings;
  }

  @override
  Future<List<ReplyComment>> getReplyComments({
    required int commentId,
  }) async {
    //
    var res = await client.from('get_replies_view').select().eq('comment_id', commentId);
    //
    List<ReplyComment> replies = res
        .map(
          (e) => ReplyCommentModel.fromJson(e),
        )
        .toList();
    //
    return replies;
  }

  @override
  Future<Unit> setAsViewedVideo({
    required int videoId,
  }) async {
    //
    try {
      var res = await client.from('videos').select('views').eq('id', videoId).limit(1);
      //
      print("res : $res");
      //
      int lastViews = res.first['views'] ?? 0;
      //
      print("views : $lastViews");
      //
      await client.from('videos').update({'views': lastViews + 1}).eq('id', videoId);
    } on Exception {
      debugPrint("getting exception while uploading set as viewed video");
    }
    //
    return unit;
  }

  @override
  Future<int> addVideo({
    required Video video,
  }) async {
    int id = -1;
    Map videoJson = VideoModel.fromClass(video).toJson();
    //
    try {
      await client.from("videos").insert(videoJson);
      var res = await client.from("videos").select().eq("url", video.url).limit(1);
      id = VideoModel.fromJson(res.first).id;
    } on Exception {
      debugPrint("getting exception while uploading video");
    }
    //
    return id;
  }
}

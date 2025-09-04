import 'package:moatmat_app/Features/video/data/models/reply_comment_m.dart';
import 'package:moatmat_app/Features/video/domain/entites/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.comment,
    required super.username,
    required super.userId,
    required super.likes,
    required super.videoId,
    required super.repliesNum,
    required super.createdAt,
    super.replies,
  });

  factory CommentModel.fromJson(Map json, {bool reply = false}) {
    return CommentModel(
      id: json["id"],
      videoId: json["video_id"],
      comment: json["comment_text"],
      likes: json["likes"],
      username: json["user_name"],
      userId: json["user_id"],
      repliesNum: json["replies_num"],
      createdAt: json["created_at"],
      replies: reply
          ? (json["replies"] as List<dynamic>?)
              ?.map(
                (e) => ReplyCommentModel.fromJson(e as Map<String, dynamic>),
              )
              .toList()
          : [],
    );
  }
  factory CommentModel.fromClass(Comment comment) {
    return CommentModel(
      id: comment.id,
      comment: comment.comment,
      username: comment.username,
      userId: comment.userId,
      likes: comment.likes,
      videoId: comment.videoId,
      repliesNum: comment.repliesNum,
      createdAt: comment.createdAt,
      replies: comment.replies?.map((e) => ReplyCommentModel.fromClass(e)).toList(),
    );
  }
  toJson({bool addId = false}) {
    return {
      if (addId) "id": id,
      "comment_text": comment,
      "user_id": userId,
      "video_id": videoId,
    };
  }
}

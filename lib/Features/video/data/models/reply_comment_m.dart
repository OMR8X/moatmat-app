import 'package:moatmat_app/Features/video/domain/entites/reply_comment.dart';

class ReplyCommentModel extends ReplyComment {
  ReplyCommentModel({
    required super.id,
    required super.username,
    required super.comment,
    required super.likes,
    required super.commentId,
    required super.userId,
    required super.createdAt,
  });

  factory ReplyCommentModel.fromJson(Map json) {
    return ReplyCommentModel(
      id: json["id"],
      comment: json["comment_text"],
      likes: json["likes"],
      commentId: json["comment_id"],
      username: json["user_name"],
      userId: json["user_id"],
      createdAt: json["created_at"],
    );
  }
  factory ReplyCommentModel.fromClass(ReplyComment replyComment) {
    return ReplyCommentModel(
      id: replyComment.id,
      comment: replyComment.comment,
      username: replyComment.username,
      likes: replyComment.likes,
      commentId: replyComment.commentId,
      userId: replyComment.userId,
      createdAt: replyComment.createdAt,
    );
  }
  toJson({bool addId = false}) {
    return {
      if (addId) "id": id,
      "comment_text": comment,
      "comment_id": commentId,
      "user_id": userId,
      "likes": likes,
    };
  }
}

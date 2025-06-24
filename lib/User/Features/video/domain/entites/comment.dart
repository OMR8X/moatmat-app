import 'package:moatmat_app/User/Features/video/domain/entites/reply_comment.dart';

class Comment {
  final int id;
  final String comment;
  final String username;
  final String userId;
  final List<ReplyComment>? replies;
  final int videoId;
  final int likes;
  final int repliesNum;
  final String createdAt;

  Comment({
    required this.id,
    required this.comment,
    required this.username,
    required this.userId,
    required this.likes,
    required this.videoId,
    required this.repliesNum,
    required this.createdAt,
    this.replies,
  });

  Comment copyWith({
    int? id,
    String? comment,
    String? username,
    String? userId,
    List<ReplyComment>? replies,
    int? likes,
    int? videoId,
    int? repliesNum,
    String? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      username: username ?? this.username,
      userId: userId ?? this.userId,
      replies: replies ?? this.replies,
      likes: likes ?? this.likes,
      videoId: videoId ?? this.videoId,
      repliesNum: repliesNum ?? this.repliesNum,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

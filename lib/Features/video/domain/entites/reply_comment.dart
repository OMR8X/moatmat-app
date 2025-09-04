class ReplyComment {
  final int id;
  final String userId;
  final String username;
  final int commentId;
  final String comment;
  final int likes;
  final String createdAt;

  ReplyComment({
    required this.id,
    required this.username,
    required this.comment,
    required this.likes,
    required this.commentId,
    required this.userId,
    required this.createdAt,
  });

  ReplyComment copyWith({
    int? id,
    String? username,
    String? comment,
    int? commentId,
    int? likes,
    String? userId,
    String? createdAt,
  }) {
    return ReplyComment(
      id: id ?? this.id,
      username: username ?? this.username,
      comment: comment ?? this.comment,
      commentId: commentId ?? this.commentId,
      likes: likes ?? this.likes,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

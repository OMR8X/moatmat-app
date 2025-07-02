class Rating {
  final int id;
  final String comment;
  final String username;
  final int videoId;
  final String userId;
  final int rating;
  final String createdAt;

  Rating({
    required this.id,
    required this.comment,
    required this.username,
    required this.rating,
    required this.videoId,
    required this.userId,
    required this.createdAt,
  });

  Rating copyWith({
    int? id,
    String? comment,
    String? username,
    int? videoId,
    String? userId,
    int? rating,
    String? createdAt,
  }) {
    return Rating(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      username: username ?? this.username,
      rating: rating ?? this.rating,
      videoId: videoId ?? this.videoId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

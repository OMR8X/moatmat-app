import 'package:moatmat_app/Features/video/domain/entites/rating.dart';

class RatingModel extends Rating {
  RatingModel({
    required super.id,
    required super.comment,
    required super.username,
    required super.rating,
    required super.videoId,
    required super.userId,
    required super.createdAt,
  });

  factory RatingModel.fromJson(Map json) {
    return RatingModel(
      id: json["id"],
      comment: json["comment"],
      userId: json["user_id"],
      videoId: json["video_id"],
      rating: json["rating"],
      username: json["user_name"],
      createdAt: json["created_at"],
    );
  }
  factory RatingModel.fromClass(Rating rating) {
    return RatingModel(
      id: rating.id,
      comment: rating.comment,
      rating: rating.rating,
      username: rating.username,
      videoId: rating.videoId,
      userId: rating.userId,
      createdAt: rating.createdAt,
    );
  }
  toJson({bool addId = false}) {
    return {
      if (addId) "id": id,
      "comment": comment,
      "rating": rating,
      "video_id": videoId,
      "user_id": userId,
    };
  }
}

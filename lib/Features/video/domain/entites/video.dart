import 'package:moatmat_app/Features/video/domain/entites/comment.dart';
import 'package:moatmat_app/Features/video/domain/entites/rating.dart';

class Video {
  final int id;
  final String url;
  final double rating;
  final int ratingNum;
  final int views;
  final List<Rating>? ratingComments;
  final List<Comment>? comments;

  Video({
    required this.id,
    required this.url,
    required this.rating,
    required this.ratingNum,
    required this.views,
    this.ratingComments,
    this.comments,
  });

  Video copyWith({
    int? id,
    String? url,
    double? rating,
    int? ratingNum,
    int? views,
    List<Rating>? ratingComments,
    List<Comment>? comments,
  }) {
    return Video(
      id: id ?? this.id,
      url: url ?? this.url,
      rating: rating ?? this.rating,
      ratingNum: ratingNum ?? this.ratingNum,
      views: views ?? this.views,
      ratingComments: ratingComments ?? this.ratingComments,
      comments: comments ?? this.comments,
    );
  }
}

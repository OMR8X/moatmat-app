import 'package:moatmat_app/User/Features/video/data/models/comment_m.dart';
import 'package:moatmat_app/User/Features/video/data/models/rating_m.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/video.dart';

class VideoModel extends Video {
  VideoModel({
    required super.id,
    required super.url,
    required super.rating,
    required super.ratingNum,
    required super.views,
    super.ratingComments,
    super.comments,
  });

  factory VideoModel.fromJson(Map json,{bool comments = false}) {
    return VideoModel(
      id: json["id"],
      rating: json["rating"],
      ratingNum: json["rating_num"],
      url: json["url"],
      views: json["views"],
      ratingComments: comments ? (json["ratingComments"] as List<dynamic>?)
        ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
        .toList() : [],
      comments: comments ? (json["comment"] as List<dynamic>?)
        ?.map((e) => CommentModel.fromJson(e as Map<String,dynamic>))
        .toList() : [],
    );
  }
  factory VideoModel.fromClass(Video video) {
    return VideoModel(
      id: video.id,
      rating: video.rating,
      ratingNum: video.ratingNum,
      url: video.url,
      views: video.views,
    );
  }
  toJson({bool addId = false}) {
    return {
      if (addId) "id": id,
      "rating" : rating,
      "rating_num" : ratingNum,
      "url" : url,
      "views" : views,
      "replies" :  ratingComments
        ?.map((e) => RatingModel.fromClass(e).toJson())
        .toList(),
      "comment" : comments
        ?.map((e)=> CommentModel.fromClass(e).toJson())
        .toList(),
    };
  }
}

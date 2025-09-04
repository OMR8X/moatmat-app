import 'package:moatmat_app/Features/video/data/models/comment_m.dart';
import 'package:moatmat_app/Features/video/data/models/rating_m.dart';
import 'package:moatmat_app/Features/video/domain/entites/video.dart';

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

  factory VideoModel.fromJson(Map json,{bool comments = false,bool tests = false,}) {
    return VideoModel(
      id: json["id"],
      rating: tests ? 0.0 :json["rating"],
      ratingNum: tests ? 0 : json["rating_num"],
      url: json["url"],
      views: tests ? 0 : json["views"],
      ratingComments: comments ? (json["ratingComments"] as List<dynamic>?)
        ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
        .toList() : tests ? [] : [],
      comments: comments ? (json["comment"] as List<dynamic>?)
        ?.map((e) => CommentModel.fromJson(e as Map<String,dynamic>))
        .toList() : tests ? [] : [],
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
  toJson({bool addId = false,bool tests = false,}) {
    return {
      if (addId) "id": id,
      if(!tests) "rating" : rating,
      if(!tests) "rating_num" : ratingNum,
      "url" : url,
      if(!tests) "views" : views,
      if(!tests) "replies" :  ratingComments
        ?.map((e) => RatingModel.fromClass(e).toJson())
        .toList(),
      if(!tests) "comment" : comments
        ?.map((e)=> CommentModel.fromClass(e).toJson())
        .toList(),
    };
  }
}

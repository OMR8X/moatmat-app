part of 'video_bloc.dart';

sealed class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

class LoadVideo extends VideoEvent {
  final int videoId;

  const LoadVideo({required this.videoId});

  @override
  List<Object> get props => [videoId];
}

class LoadComments extends VideoEvent {
  final int videoId;

  const LoadComments({required this.videoId});

  @override
  List<Object> get props => [videoId];
}

class LoadReplies extends VideoEvent {
  final int commentId;

  const LoadReplies({required this.commentId});

  @override
  List<Object> get props => [commentId];
}

class AddComment extends VideoEvent {
  final String commentText;
  final int videoId;

  const AddComment({required this.commentText, required this.videoId});

  @override
  List<Object> get props => [commentText, videoId];
}

class AddReply extends VideoEvent {
  final String replyText;
  final int commentId;

  const AddReply({
    required this.replyText,
    required this.commentId,
  });

  @override
  List<Object> get props => [replyText, commentId];
}

class AddRating extends VideoEvent {
  final int rating;
  final int videoId;

  const AddRating({
    required this.rating,
    required this.videoId,
  });

  @override
  List<Object> get props => [videoId, rating];
}

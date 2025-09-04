part of 'video_bloc.dart';

enum Loading { video, comment, replies, rating }

class VideoState extends Equatable {
  final Video? video;
  final List<Comment>? comments;
  final Rating? myRating;
  final Map<int, List<ReplyComment>> repliesMap; // commentId -> replies
  final String? errorMsg;
  final Map<Loading, bool> isLoading;
  final Set<int> loadingRepliesForComments;
  final bool? addReplies;

  VideoState({
    this.video,
    this.myRating,
    this.comments,
    this.repliesMap = const {},
    Map<Loading, bool>? isLoading,
    this.errorMsg,
    this.loadingRepliesForComments = const {},
    this.addReplies = false,
  }) : isLoading = isLoading ??
            {
              Loading.video: false,
              Loading.comment: false,
              Loading.replies: false,
              Loading.rating: false,
            };

  VideoState copyWith({
    Video? video,
    List<Comment>? comments,
    Rating? myRating,
    Map<int, List<ReplyComment>>? repliesMap,
    String? errorMsg,
    final Map<Loading, bool>? isLoading,
    Set<int>? loadingRepliesForComments,
    bool? addReplies,
  }) {
    return VideoState(
      video: video ?? this.video,
      comments: comments ?? this.comments,
      myRating: myRating ?? this.myRating,
      repliesMap: repliesMap ?? this.repliesMap,
      errorMsg: errorMsg,
      isLoading: isLoading ?? this.isLoading,
      loadingRepliesForComments: loadingRepliesForComments ?? this.loadingRepliesForComments,
      addReplies: addReplies ?? this.addReplies,
    );
  }

  @override
  List<Object?> get props => [
        video,
        comments,
        myRating,
        repliesMap,
        errorMsg,
        isLoading,
        loadingRepliesForComments,
        addReplies,
      ];
}

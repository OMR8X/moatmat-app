part of 'comment_cubit.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

final class CommentInitial extends CommentState {}

final class CommentLoadind extends CommentState {}

class CommentSuccess extends CommentState {
  final String msg;

  const CommentSuccess({required this.msg});

  @override
  List<Object> get props => [msg];
}

final class CommentError extends CommentState {
  final String msg;

  const CommentError({required this.msg});

  @override
  List<Object> get props => [msg];
}

final class CommentLoaded extends CommentState {
  final List<Comment> comments;

  const CommentLoaded({required this.comments});

  @override
  List<Object> get props => [];
}

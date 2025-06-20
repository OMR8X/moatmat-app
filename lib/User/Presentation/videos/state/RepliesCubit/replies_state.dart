part of 'replies_cubit.dart';

sealed class RepliesState extends Equatable {
  const RepliesState();

  @override
  List<Object> get props => [];
}

final class RepliesInitial extends RepliesState {}

class RepliesLoading extends RepliesState {}

class RepliesLoaded extends RepliesState {
  final List<ReplyComment> replies;

  const RepliesLoaded({required this.replies});

  @override
  List<Object> get props => [replies];
}

class RepliesError extends RepliesState {
  final String msg;

  const RepliesError({required this.msg});

  @override
  List<Object> get props => [msg];
}
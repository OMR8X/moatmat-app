part of 'my_rating_to_video_cubit.dart';

sealed class MyRatingToVideoState extends Equatable {
  const MyRatingToVideoState();

  @override
  List<Object> get props => [];
}

final class MyRatingToVideoInitial extends MyRatingToVideoState {}

final class MyRatingToVideoError extends MyRatingToVideoState {
  final String msg;

  const MyRatingToVideoError({required this.msg});

  @override
  List<Object> get props => [msg];
}

final class MyRatingToVideoLoading extends MyRatingToVideoState {}

final class MyRatingToVideoLoaded extends MyRatingToVideoState {
  final int myRating;

  const MyRatingToVideoLoaded({required this.myRating});

  @override
  List<Object> get props => [myRating];
}
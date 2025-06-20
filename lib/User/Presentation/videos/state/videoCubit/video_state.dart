part of 'video_cubit.dart';

sealed class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

final class VideoInitial extends VideoState {}

final class VideoLoading extends VideoState {}

final class VideoError extends VideoState {
  final String msg;

  const VideoError({required this.msg});

  @override
  List<Object> get props => [msg];
}

final class VideoLoaded extends VideoState {
  final Video video;

  const VideoLoaded({
    required this.video,
  });

  @override
  List<Object> get props => [
        video
      ];
}

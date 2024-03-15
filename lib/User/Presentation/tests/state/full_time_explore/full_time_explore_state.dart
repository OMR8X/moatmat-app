part of 'full_time_explore_cubit.dart';

sealed class FullTimeExploreState extends Equatable {
  const FullTimeExploreState();

  @override
  List<Object> get props => [];
}

final class FullTimeExploreInitial extends FullTimeExploreState {}

final class FullTimeExploreLoading extends FullTimeExploreState {}

final class FullTimeExploreQuestion extends FullTimeExploreState {
  //
  final (TestQuestion, int?) question;
  //
  final Duration time;
  //
  final int currentQ, length;

  const FullTimeExploreQuestion({
    required this.question,
    required this.time,
    required this.currentQ,
    required this.length,
  });

  @override
  List<Object> get props => [question, currentQ, length, time];
}

final class FullTimeExploreResult extends FullTimeExploreState {
  final List<(TestQuestion, int)> correct, wrong;
  final String result;

  const FullTimeExploreResult({
    required this.correct,
    required this.wrong,
    required this.result,
  });
  @override
  List<Object> get props => [correct, wrong, result];
}

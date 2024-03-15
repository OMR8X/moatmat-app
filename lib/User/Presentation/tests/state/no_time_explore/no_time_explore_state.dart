part of 'no_time_explore_cubit.dart';

sealed class NoTimeExploreState extends Equatable {
  const NoTimeExploreState();

  @override
  List<Object> get props => [];
}

final class NoTimeExploreLoading extends NoTimeExploreState {}

final class NoTimeExploreQuestion extends NoTimeExploreState {
  //
  final (TestQuestion, int?) question;
  //
  final int currentQ, length;

  const NoTimeExploreQuestion({
    required this.question,
    required this.currentQ,
    required this.length,
  });
  @override
  List<Object> get props => [question, currentQ, length];
}

final class NoTimeExploreResult extends NoTimeExploreState {
  final List<(TestQuestion, int)> correct, wrong;
  final String result;

  const NoTimeExploreResult({
    required this.correct,
    required this.wrong,
    required this.result,
  });
  @override
  List<Object> get props => [correct, wrong, result];
}

part of 'per_question_explore_cubit.dart';

sealed class PerQuestionExploreState extends Equatable {
  const PerQuestionExploreState();

  @override
  List<Object> get props => [];
}

final class PerQuestionExploreLoading extends PerQuestionExploreState {}

final class PerQuestionExploreQuestion extends PerQuestionExploreState {
  //
  final (BankQuestion, int?) question;
  //
  final Duration time;
  //
  final int currentQ, length;

  const PerQuestionExploreQuestion({
    required this.question,
    required this.time,
    required this.currentQ,
    required this.length,
  });

  @override
  List<Object> get props => [question, currentQ, length, time];
}

final class PerQuestionExploreResult extends PerQuestionExploreState {
  final List<(BankQuestion, int)> correct, wrong;
  final String result;

  const PerQuestionExploreResult({
    required this.correct,
    required this.wrong,
    required this.result,
  });
  @override
  List<Object> get props => [correct, wrong, result];
}

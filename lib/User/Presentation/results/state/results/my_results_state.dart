part of 'my_results_cubit.dart';

sealed class MyResultsState extends Equatable {
  const MyResultsState();

  @override
  List<Object> get props => [];
}

final class MyResultsLoading extends MyResultsState {}

final class MyResultsError extends MyResultsState {
  final String error;

  const MyResultsError({required this.error});
}

final class MyResultsInitial extends MyResultsState {
  final List<Result> testsResults;
  final List<Result> banksResults;
  final List<Result> outerResults;

  const MyResultsInitial({
    required this.testsResults,
    required this.banksResults,
    required this.outerResults,
  });

  @override
  List<Object> get props => [testsResults, banksResults];
}

final class MyResultsExploreResult extends MyResultsState {
  final bool showTrueAnswers;
  final double mark;
  final List<(Question?, int?)> wrongAnswers;

  const MyResultsExploreResult({
    required this.wrongAnswers,
    required this.showTrueAnswers,
    required this.mark,
  });
}

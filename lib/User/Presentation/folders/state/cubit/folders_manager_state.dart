part of 'folders_manager_cubit.dart';

sealed class FoldersManagerState extends Equatable {
  const FoldersManagerState();

  @override
  List<Object> get props => [];
}

final class FoldersManagerLoading extends FoldersManagerState {}

final class FoldersManagerError extends FoldersManagerState {
  final String error;

  const FoldersManagerError({
    required this.error,
  });
}

final class FoldersManagerExploreFolder extends FoldersManagerState {
  final List<String> folders;
  final List<Test> tests;
  final List<Bank> banks;
  final bool canPop;

  const FoldersManagerExploreFolder({
    required this.canPop,
    required this.folders,
    required this.tests,
    required this.banks,
  });

  @override
  List<Object> get props {
    return [
      folders,
      tests,
      banks,
      canPop,
      banks.map((e) => e.isPurchased()),
      tests.map((e) => e.isPurchased()),
    ];
  }
}

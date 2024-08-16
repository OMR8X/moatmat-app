part of 'codes_centers_cubit.dart';

sealed class CodesCentersState extends Equatable {
  const CodesCentersState();

  @override
  List<Object> get props => [];
}

final class CodesCentersLoading extends CodesCentersState {}

final class CodesCentersError extends CodesCentersState {
  final String error;

  const CodesCentersError({required this.error});
}

final class CodesCentersGovernorates extends CodesCentersState {
  final List<String> governorates;

  const CodesCentersGovernorates({required this.governorates});

  @override
  List<Object> get props => [governorates];
}

final class CodesCentersExplore extends CodesCentersState {
  final List<CodeCenter> centers;

  const CodesCentersExplore({
    required this.centers,
  });
  @override
  List<Object> get props => [centers];
}

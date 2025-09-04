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

final class CodesCentersGovernorate extends CodesCentersState {
  final List<String> governorate;

  const CodesCentersGovernorate({required this.governorate});

  @override
  List<Object> get props => [governorate];
}

final class CodesCentersExplore extends CodesCentersState {
  final String governorate;
  final List<CodeCenter> centers;

  const CodesCentersExplore({
    required this.governorate,
    required this.centers,
  });
  @override
  List<Object> get props => [centers];
}

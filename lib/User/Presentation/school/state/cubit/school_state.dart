part of 'school_cubit.dart';

sealed class SchoolState extends Equatable {
  const SchoolState();

  @override
  List<Object> get props => [];
}

final class SchoolInitial extends SchoolState {}

final class SchoolLoading extends SchoolState {}

final class SchoolFailed extends SchoolState {
  final String msg;

  const SchoolFailed({required this.msg});

  @override
  List<Object> get props => [msg];
}

final class SchoolLoaded extends SchoolState {
  final List<School> schools;

  const SchoolLoaded({required this.schools});

  @override
  List<Object> get props => [schools];
}

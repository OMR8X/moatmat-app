part of 'get_test_cubit.dart';



sealed class GetTestState extends Equatable {
  const GetTestState({this.error});
  final String? error;
  @override
  List<Object> get props => error != null ? [error!] : [];
}

final class GetTestLoading extends GetTestState {
  const GetTestLoading({super.error});
}

final class GetTestSelectMaterial extends GetTestState {
  final List<String> materials;

  const GetTestSelectMaterial({
    required this.materials,
    super.error,
  });
  @override
  List<Object> get props => [materials];
}

final class GetTestSelectClass extends GetTestState {
  final List<(String, int)> classes;

  const GetTestSelectClass({
    required this.classes,
    super.error,
  });
  @override
  List<Object> get props => [classes];
}

final class GetTestSelectTeacher extends GetTestState {
  final List<(String, int)> teachers;

  const GetTestSelectTeacher({
    required this.teachers,
    super.error,
  });
  @override
  List<Object> get props => [teachers];
}

final class GetTestSelectTest extends GetTestState {
  final List<(Test, int)> tests;
  final String teacher;

  const GetTestSelectTest({
    required this.teacher,
    required this.tests,
    super.error,
  });
  @override
  List<Object> get props => [tests];
}


part of 'school_tests_bloc.dart';

abstract class SchoolTestsState extends Equatable {
  const SchoolTestsState();

  @override
  List<Object?> get props => [];
}

class SchoolTestsInitial extends SchoolTestsState {
  final List<School> schools;

  const SchoolTestsInitial({required this.schools});
  @override
  List<Object?> get props => [schools];
}

class SchoolTestsPickMaterialState extends SchoolTestsState {
  const SchoolTestsPickMaterialState();
  @override
  List<Object?> get props => [];
}

class SchoolTestsLoading extends SchoolTestsState {}

class PickSchoolState extends SchoolTestsState {
  final String? selectedSchoolId;
  final String? selectedSchoolName;

  const PickSchoolState({
    this.selectedSchoolId,
    this.selectedSchoolName,
  });

  @override
  List<Object?> get props => [selectedSchoolId, selectedSchoolName];
}

class PickClassState extends SchoolTestsState {
  final List<(String, int)> classes;
  const PickClassState({
    required this.classes,
  });

  @override
  List<Object?> get props => [
        classes,
      ];
}

class PickTeacherState extends SchoolTestsState {
  final List<(TeacherData, int)> teachers;

  const PickTeacherState({
    required this.teachers,
  });

  @override
  List<Object?> get props => [
        teachers,
      ];
}

class ExploreTeacherState extends SchoolTestsState {
  final TeacherData teacher;

  const ExploreTeacherState({
    required this.teacher,
  });

  @override
  List<Object?> get props => [
        teacher,
      ];
}

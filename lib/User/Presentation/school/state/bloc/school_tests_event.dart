part of 'school_tests_bloc.dart';

abstract class SchoolTestsEvent extends Equatable {
  const SchoolTestsEvent();

  @override
  List<Object?> get props => [];
}

class InitializeSchoolsTestsEvent extends SchoolTestsEvent {
  const InitializeSchoolsTestsEvent();

  @override
  List<Object?> get props => [];
}

class SetSchoolEvent extends SchoolTestsEvent {
  final School? school;

  const SetSchoolEvent({
    this.school,
  });

  @override
  List<Object?> get props => [school];
}

class SetClassEvent extends SchoolTestsEvent {
  final String className;

  const SetClassEvent({
    required this.className,
  });

  @override
  List<Object?> get props => [className];
}

class SetTeacherEvent extends SchoolTestsEvent {
  final TeacherData teacherData;

  const SetTeacherEvent({
    required this.teacherData,
  });

  @override
  List<Object?> get props => [teacherData];
}

class BackEvent extends SchoolTestsEvent {
  const BackEvent();
}

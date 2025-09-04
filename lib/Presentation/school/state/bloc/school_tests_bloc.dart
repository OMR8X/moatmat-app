import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_app/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_app/Features/school/domain/entities/school.dart';
import 'package:moatmat_app/Features/school/domain/usecases/get_schools_usecase.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/get_school_test_classes_uc.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/get_school_tests_teacher_uc.dart';

part 'school_tests_event.dart';
part 'school_tests_state.dart';

class SchoolTestsBloc extends Bloc<SchoolTestsEvent, SchoolTestsState> {
  final GetSchoolUc _getSchoolUc;
  final GetSchoolTestClassesUC _getSchoolTestClassesUC;
  final GetSchoolTestsTeacherUC _getSchoolTestsTeacherUC;
  SchoolTestsBloc(this._getSchoolUc, this._getSchoolTestClassesUC, this._getSchoolTestsTeacherUC) : super(SchoolTestsLoading()) {
    on<SetSchoolEvent>(_onSetSchool);
    on<InitializeSchoolsTestsEvent>(_onInitializeSchoolsTests);
    on<SetClassEvent>(_onSetClass);
    on<SetMaterialEvent>(_onSetMaterial);
    on<SetTeacherEvent>(_onSetTeacher);
    on<BackEvent>(_onBack);
  }
  String selectedSchoolId = "";
  String selectedClass = "";
  String selectedMaterial = "";

  void _onInitializeSchoolsTests(InitializeSchoolsTestsEvent event, Emitter<SchoolTestsState> emit) async {
    emit(SchoolTestsLoading());
    await _getSchoolUc.call().then((value) async {
      value.fold((l) async {
        await Fluttertoast.showToast(msg: l.message);
        emit(SchoolTestsLoading());
      }, (r) {
        emit(SchoolTestsInitial(schools: r));
      });
    });
  }

  void _onSetSchool(SetSchoolEvent event, Emitter<SchoolTestsState> emit) async {
    emit(SchoolTestsLoading());
    selectedSchoolId = (event.school?.id ?? selectedSchoolId).toString();
    emit(SchoolTestsPickMaterialState());
  }

  void _onSetMaterial(SetMaterialEvent event, Emitter<SchoolTestsState> emit) async {
    selectedMaterial = event.materialName;
    emit(SchoolTestsLoading());
    await _getSchoolTestClassesUC.call(schoolId: (selectedSchoolId).toString(), material: selectedMaterial).then((value) async {
      value.fold((l) async {
        await Fluttertoast.showToast(msg: l.message);
        emit(SchoolTestsLoading());
      }, (r) {
        emit(PickClassState(classes: r));
      });
    });
  }

  void _onSetClass(SetClassEvent event, Emitter<SchoolTestsState> emit) async {
    emit(SchoolTestsLoading());
    await _getSchoolTestsTeacherUC.call(schoolId: selectedSchoolId, clas: event.className, material: selectedMaterial).then((value) async {
      value.fold((l) async {
        await Fluttertoast.showToast(msg: l.message);
        emit(SchoolTestsLoading());
      }, (r) {
        selectedClass = event.className;
        emit(PickTeacherState(teachers: r));
      });
    });
  }

  void _onSetTeacher(SetTeacherEvent event, Emitter<SchoolTestsState> emit) async {
    emit(ExploreTeacherState(teacher: event.teacherData));
  }

  void _onBack(BackEvent event, Emitter<SchoolTestsState> emit) {
    // if (state is PickTeacherState) {
    //   // Go back from teacher selection to class selection
    //   final currentState = state as PickTeacherState;
    //   emit(PickClassState(
    //     selectedSchoolId: currentState.selectedSchoolId,
    //     selectedSchoolName: currentState.selectedSchoolName,
    //     selectedClassId: currentState.selectedClassId,
    //     selectedClassName: currentState.selectedClassName,
    //   ));
    // } else if (state is PickClassState) {
    //   // Go back from class selection to school selection
    //   emit(PickSchoolState());
    // } else if (state is PickSchoolState) {
    //   // Go back to initial state
    //   // emit(SchoolTestsInitial());
    //   _onInitializeSchoolsTests(InitializeSchoolsTestsEvent(), emit);
    // }
  }
}

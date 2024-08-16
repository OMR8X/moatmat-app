import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Core/constant/materials.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/get_teacher_tests_uc.dart';
import '../../../../Features/tests/domain/usecases/get_material_test_classes_uc.dart';
import '../../../../Features/tests/domain/usecases/get_material_tests_teacher_uc.dart';

part 'get_test_state.dart';

class GetTestCubit extends Cubit<GetTestState> {
  GetTestCubit() : super(const GetTestLoading());
  //
  List<String> materials = [];
  List<(String, int)> classes = [];
  List<(TeacherData, int)> teachers = [];
  List<(Test, int)> tests = [];
  //
  String? material;
  String? clas;
  TeacherData? teacherData;
  Test? test;
  init() async {
    emit(const GetTestLoading());
    materials = materialsLst.map((e) => e["name"]!).toList();
    emit(GetTestSelectMaterial(materials: materials));
  }

  //
  selecteMaterial(String material) async {
    emit(const GetTestLoading());
    this.material = material;
    var res = locator<GetMaterialTestClassesUC>().call(material: material);
    await res.then((value) {
      value.fold(
        (l) {
          emit(GetTestSelectMaterial(
            materials: materials,
            error: l.text,
          ));
        },
        (r) {
          classes = r;
          emit(GetTestSelectClass(classes: classes));
        },
      );
    });
  }

  //
  selecteClass(String clas) async {
    emit(const GetTestLoading());
    this.clas = clas;
    var res = locator<GetMaterialTestsTeachersUC>().call(
      clas: clas,
      material: material!,
    );
    await res.then((value) {
      value.fold(
        (l) {
          emit(GetTestSelectClass(classes: classes, error: l.text));
        },
        (r) {
          teachers = r;
          emit(GetTestSelectTeacher(teachers: teachers));
        },
      );
    });
  }

  //
  selectTeacher(TeacherData teacherData, {bool disableLoading = false}) async {
    if (!disableLoading) {
      emit(const GetTestLoading());
    }
    this.teacherData = teacherData;
    var res = locator<GetTeacherTestsUC>().call(
      teacherEmail: teacherData.email,
      clas: clas!,
      material: material!,
    );
    await res.then((value) {
      value.fold(
        (l) {
          emit(GetTestSelectTeacher(teachers: teachers, error: l.text));
        },
        (r) {
          tests = r;
          List<String> folders = r.map((e) => e.$1.information.folder).toList();
          emit(GetTestSelectFolder(folders: folders, teacherData: teacherData));
        },
      );
    });
  }

  selectFolder(String folder) {
    emit(GetTestSelectTest(
      tests: tests.where((e) => e.$1.information.folder == folder).toList(),
      title: folder,
    ));
  }

  //


  //
  backToMaterials() {
    emit(GetTestSelectMaterial(materials: materials));
  }

  backToClasses() {
    emit(GetTestSelectClass(classes: classes));
  }

  backToTeachers() {
    emit(GetTestSelectTeacher(teachers: teachers));
  }

  backToFolders() {
    List<String> folders = tests.map((e) => e.$1.information.folder).toList();
    emit(GetTestSelectFolder(folders: folders, teacherData: teacherData!));
  }
}

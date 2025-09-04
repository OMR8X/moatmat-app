import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/Core/constant/materials.dart';
import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_app/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/Features/banks/domain/use_cases/get_material_bank_classes_uc.dart';
import 'package:moatmat_app/Features/banks/domain/use_cases/get_material_banks_teacher_uc.dart';
import 'package:moatmat_app/Features/banks/domain/use_cases/get_teacher_banks_uc.dart';
import 'package:moatmat_app/Features/purchase/domain/use_cases/pucrhase_list_of_item.dart';

import '../../../../Features/auth/domain/entites/user_data.dart';
import '../../../../Features/purchase/domain/entites/purchase_item.dart';

part 'get_bank_state.dart';

class GetBankCubit extends Cubit<GetBankState> {
  GetBankCubit() : super(const GetBankLoading());
  //
  List<String> materials = [];
  List<(String, int)> classes = [];
  List<(TeacherData, int)> teachers = [];
  List<(Bank, int)> banks = [];
  //
  String? material;
  String? clas;
  TeacherData? teacherData;
  Bank? bank;
  init() async {
    emit(const GetBankLoading());
    materials = materialsLst.map((e) => e["name"]!).toList();
    emit(GetBankSelecteMaterial(materials: materials));
  }

  //
  selecteMaterial(String material) async {
    emit(const GetBankLoading());
    this.material = material;
    var res = locator<GetMaterialBankClassesUC>().call(material: material);
    await res.then((value) {
      value.fold(
        (l) {
          emit(GetBankSelecteMaterial(
            materials: materials,
            error: l.message,
          ));
        },
        (r) {
          classes = r;
          emit(GetBankSelecteClass(classes: classes));
        },
      );
    });
  }

  //
  selecteClass(String clas) async {
    emit(const GetBankLoading());
    this.clas = clas;
    var res = locator<GetMaterialBanksTeachersUC>().call(
      clas: clas,
      material: material!,
    );
    await res.then((value) {
      value.fold(
        (l) {
          emit(GetBankSelecteClass(classes: classes, error: l.message));
        },
        (r) {
          teachers = r;
          emit(GetBankSelecteTeacher(teachers: teachers));
        },
      );
    });
  }

  //
  selectTeacher(TeacherData teacherData, {bool disableLoading = false}) async {
    if (!disableLoading) {
      emit(const GetBankLoading());
    }
    this.teacherData = teacherData;
    var res = locator<GetTeacherBanksUC>().call(
      teacherEmail: teacherData.email,
      clas: clas!,
      material: material!,
    );
    await res.then((value) {
      value.fold(
        (l) {
          emit(GetBankSelecteTeacher(teachers: teachers, error: l.message));
        },
        (r) {
          banks = r;
          // List<String> folders = r.map((e) => e.$1.information.folder).toList();
          emit(
            GetBankSelecteFolder(teacherData: teacherData, banks: r, material: material!),
          );
        },
      );
    });
  }

  selectFolder(String folder) {
    emit(GetBankSelecteBank(
      banks: banks.where((e) => "" == folder).toList(),
      title: folder,
    ));
  }

  //
  selecteBank(Bank bank) async {
    emit(const GetBankLoading());
    emit(GetBankDone(bank: bank));
  }

  //

  //
  refreshBanks() async {
    selectTeacher(teacherData!);
  }

  //
  backToMaterials() {
    emit(GetBankSelecteMaterial(materials: materials));
  }

  backToClasses() {
    emit(GetBankSelecteClass(classes: classes));
  }

  backToTeachers() {
    emit(GetBankSelecteTeacher(teachers: teachers));
  }

  backToFolders() {
    emit(GetBankSelecteFolder(teacherData: teacherData!, banks: const [], material: material!));
  }
}

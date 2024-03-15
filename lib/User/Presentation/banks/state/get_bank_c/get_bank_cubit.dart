import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Core/constant/materials.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_material_bank_classes_uc.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_material_banks_teacher_uc.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_teacher_banks_uc.dart';
import 'package:moatmat_app/User/Features/purchase/domain/use_cases/pucrhase_list_of_item.dart';

import '../../../../Features/auth/domain/entites/user_data.dart';
import '../../../../Features/purchase/domain/entites/purchase_item.dart';

part 'get_bank_state.dart';

class GetBankCubit extends Cubit<GetBankState> {
  GetBankCubit() : super(const GetBankLoading());
  //
  List<String> materials = [];
  List<(String, int)> classes = [];
  List<(String, int)> teachers = [];
  List<(Bank, int)> banks = [];
  //
  String? material;
  String? clas;
  String? teacher;
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
            error: l.text,
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
          emit(GetBankSelecteClass(classes: classes, error: l.text));
        },
        (r) {
          teachers = r;
          emit(GetBankSelecteTeacher(teachers: teachers));
        },
      );
    });
  }

  //
  selecteTeacher(String teacher, {bool disableLoading = false}) async {
    if (!disableLoading) {
      emit(const GetBankLoading());
    }
    this.teacher = teacher;
    var res = locator<GetTeacherBanksUC>().call(
      teacher: teacher,
      clas: clas!,
      material: material!,
    );
    await res.then((value) {
      value.fold(
        (l) {
          emit(GetBankSelecteTeacher(teachers: teachers, error: l.text));
        },
        (r) {
          banks = r;
          emit(GetBankSelecteBank(banks: banks, teacher: teacher));
        },
      );
    });
  }

  //
  selecteBank(Bank bank) async {
    emit(const GetBankLoading());
    emit(GetBankDone(bank: bank));
  }

  //

  //
  refreshBanks() async {
    selecteTeacher(teacher!);
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
}

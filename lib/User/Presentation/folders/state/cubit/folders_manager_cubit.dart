import 'dart:convert';

import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/group.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Core/services/folders_system_s.dart';
import '../../../../Features/banks/domain/entites/bank.dart';
import '../../../../Features/banks/domain/use_cases/get_banks_by_ids_uc.dart';
import '../../../../Features/tests/domain/entities/test.dart';
import '../../../../Features/tests/domain/usecases/get_tests_by_ids_uc.dart';

part 'folders_manager_state.dart';

class FoldersManagerCubit extends Cubit<FoldersManagerState> {
  FoldersManagerCubit() : super(FoldersManagerLoading());

  late bool isTest;
  late TeacherData teacher;

  ///
  late FoldersSystemService foldersSystemService;

  ///
  init({required Map<String, dynamic> directories, required bool isTest, required String material, required TeacherData teacher}) async {
    //
    this.isTest = isTest;
    this.teacher = teacher;
    //
    emit(FoldersManagerLoading());
    //
    foldersSystemService = FoldersSystemService(onUpdate: (directories) {}, directories: directories);
    //
    emit(FoldersManagerExploreFolder(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : const [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  refresh() async {
    emit(FoldersManagerLoading());
    emit(FoldersManagerExploreFolder(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  ///
  exploreDirectory(String folder) async {
    //
    emit(FoldersManagerLoading());
    //
    foldersSystemService.pushPathForward(directory: folder);
    //
    emit(FoldersManagerExploreFolder(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  popBack() async {
    //
    emit(FoldersManagerLoading());
    //
    foldersSystemService.popPathBack();
    //
    emit(FoldersManagerExploreFolder(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  ///
  createDirectory(String title) async {
    //
    emit(FoldersManagerLoading());
    //
    foldersSystemService.createDirectory(directory: title);
    //
    emit(FoldersManagerExploreFolder(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  deleteDirectory(String name) async {
    //
    emit(FoldersManagerLoading());
    //
    foldersSystemService.removeDirectory(directory: name);
    //
    emit(FoldersManagerExploreFolder(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  addItem(int item) async {
    //
    emit(FoldersManagerLoading());
    //
    foldersSystemService.addItemDirectory(item: item);
    //
    emit(FoldersManagerExploreFolder(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  removeItem(int item) async {
    //
    emit(FoldersManagerLoading());
    //
    foldersSystemService.removeItemDirectory(item: item);
    //
    emit(FoldersManagerExploreFolder(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  //
  Future<List<Bank>> getBanks(List<int> ids) async {
    List<Bank> banks = [];
    //
    var res = await locator<GetBanksByIdsUC>().call(ids: ids);
    //
    res.fold(
      (l) {},
      (r) {
        banks = r;
      },
    );
    //
    return banks;
  }

  //
  Future<List<Test>> getTests(List<int> ids) async {
    //
    List<Test> tests = [];
    List<int> courseSubscribersTests = teacher.courseSubscribersTests;
    List<Group> groups = teacher.groups;
    //
    Map<String, List<int>> holder = {};
    //
    for (var item in locator<List<PurchaseItem>>()) {
      if (item.itemType == "teacher" && item.itemId == teacher.email) {
        //
        if (holder[item.uuid] == null) holder[item.uuid] = [];
        //
        holder[item.uuid]!.addAll(courseSubscribersTests);
      }
    }
    for (var group in groups) {
      if (group.items.any((e) => e.userData.uuid == locator<UserData>().uuid)) {
        for (var item in group.items) {
          if (holder[item.userData.uuid] == null) holder[item.userData.uuid] = [];
          if (group.testsIds.contains(2197)) {
            print("debugging: yes! ${item.userData.uuid} has access to group tests with group name ${group.name}");
          }
          holder[item.userData.uuid]?.addAll(group.testsIds);
        }
      }
    }
    List<int>? availableTestsIds = holder[locator<UserData>().uuid];

    if (availableTestsIds?.isNotEmpty ?? false) {
      ids = ids.toSet().intersection(availableTestsIds!.toSet()).toList();
    }
    availableTestsIds?.reversed;
    // print("debugging: ${locator<UserData>().uuid}");
    print("debugging: availableTestsIds $availableTestsIds ");
    var res = await locator<GetTestsByIdsUC>().call(ids: ids, showHidden: availableTestsIds != null);
    res.fold((l) {}, (r) => tests = r);
    return tests;
  }
}

Map<String, dynamic> deepCopy(Map<String, dynamic> original) {
  return jsonDecode(jsonEncode(original)) as Map<String, dynamic>;
}

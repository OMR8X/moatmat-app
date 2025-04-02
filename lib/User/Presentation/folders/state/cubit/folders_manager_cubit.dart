import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Core/services/folders_system_s.dart';
import '../../../../Features/banks/domain/entites/bank.dart';
import '../../../../Features/banks/domain/use_cases/get_banks_by_ids_uc.dart';
import '../../../../Features/tests/domain/entities/test.dart';
import '../../../../Features/tests/domain/repository/get_tests_by_ids_uc.dart';

part 'folders_manager_state.dart';

class FoldersManagerCubit extends Cubit<FoldersManagerState> {
  FoldersManagerCubit() : super(FoldersManagerLoading());
  late bool isTest;

  ///
  late FoldersSystemService foldersSystemService;

  ///
  init({required Map<String, dynamic> directories, required bool isTest, required String material}) async {
    //
    this.isTest = isTest;
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
    //
    List<Test> tests = [];
    //
    var res = await locator<GetTestsByIdsUC>().call(ids: ids);
    //
    res.fold(
      (l) {},
      (r) {
        tests = r;
      },
    );
    //
    return tests;
  }
}

Map<String, dynamic> deepCopy(Map<String, dynamic> original) {
  return jsonDecode(jsonEncode(original)) as Map<String, dynamic>;
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/get_cached_tests_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/clear_cached_tests_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/delete_cached_test_uc.dart';

part 'offline_tests_event.dart';
part 'offline_tests_state.dart';

class OfflineTestsBloc extends Bloc<OfflineTestsEvent, OfflineTestsState> {
  final GetCachedTestsUC _getCachedTestsUsecase;
  final ClearCachedTestsUC _clearCachedTestsUsecase;
  final DeleteCachedTestUC _deleteCachedTestUsecase;

  OfflineTestsBloc({
    required GetCachedTestsUC getCachedTestsUsecase,
    required ClearCachedTestsUC clearCachedTestsUsecase,
    required DeleteCachedTestUC deleteCachedTestUsecase,
  })  : _getCachedTestsUsecase = getCachedTestsUsecase,
        _clearCachedTestsUsecase = clearCachedTestsUsecase,
        _deleteCachedTestUsecase = deleteCachedTestUsecase,
        super(OfflineTestsMaterialPicker()) {
    on<InitializeOfflineTests>(_onInitializeOfflineTests);
    on<SelectMaterial>(_onSelectMaterial);
    on<DeleteTestFromCache>(_onDeleteTestFromCache);
    on<ClearAllCachedTests>(_onClearAllCachedTests);
    on<ResetToMaterialPicker>(_onResetToMaterialPicker);
  }

  Future<void> _onInitializeOfflineTests(
    InitializeOfflineTests event,
    Emitter<OfflineTestsState> emit,
  ) async {
    // Start with material picker instead of loading directly
    emit(OfflineTestsMaterialPicker());
  }

  Future<void> _onSelectMaterial(
    SelectMaterial event,
    Emitter<OfflineTestsState> emit,
  ) async {
    emit(OfflineTestsLoading());

    final result = await _getCachedTestsUsecase();

    result.fold(
      (failure) => emit(OfflineTestsInitial(
        selectedMaterial: event.material,
        cachedTests: [],
        message: failure.message,
      )),
      (allTests) {
        // Filter tests by selected material
        final filteredTests = _filterTestsByMaterial(allTests, event.material);

        emit(OfflineTestsInitial(
          selectedMaterial: event.material,
          cachedTests: filteredTests,
          message: filteredTests.isEmpty ? "لا توجد اختبارات محفوظة لمادة ${event.material}" : null,
        ));
      },
    );
  }

  Future<void> _onDeleteTestFromCache(
    DeleteTestFromCache event,
    Emitter<OfflineTestsState> emit,
  ) async {
    if (state is OfflineTestsInitial) {
      final currentState = state as OfflineTestsInitial;
      emit(OfflineTestsLoading());

      final deleteResult = await _deleteCachedTestUsecase(testId: event.testId);

      deleteResult.fold(
        (failure) => emit(OfflineTestsInitial(
          selectedMaterial: currentState.selectedMaterial,
          cachedTests: currentState.cachedTests,
          message: "خطأ في حذف الاختبار",
        )),
        (_) {
          final updatedTests = currentState.cachedTests.where((test) => test.id != event.testId).toList();

          emit(OfflineTestsInitial(
            selectedMaterial: currentState.selectedMaterial,
            cachedTests: updatedTests,
            message: updatedTests.isEmpty ? "لا توجد اختبارات محفوظة لمادة ${currentState.selectedMaterial}" : "تم حذف الاختبار",
          ));
        },
      );
    }
  }

  Future<void> _onClearAllCachedTests(
    ClearAllCachedTests event,
    Emitter<OfflineTestsState> emit,
  ) async {
    if (state is OfflineTestsInitial) {
      final currentState = state as OfflineTestsInitial;
      emit(OfflineTestsLoading());

      final clearResult = await _clearCachedTestsUsecase();

      clearResult.fold(
        (failure) => emit(OfflineTestsInitial(
          selectedMaterial: currentState.selectedMaterial,
          cachedTests: currentState.cachedTests,
          message: "خطأ في حذف جميع الاختبارات",
        )),
        (_) => emit(OfflineTestsInitial(
          selectedMaterial: currentState.selectedMaterial,
          cachedTests: [],
          message: "تم حذف جميع الاختبارات",
        )),
      );
    }
  }

  void _onResetToMaterialPicker(
    ResetToMaterialPicker event,
    Emitter<OfflineTestsState> emit,
  ) {
    emit(OfflineTestsMaterialPicker());
  }

  /// Filters tests by the selected material
  List<Test> _filterTestsByMaterial(List<Test> tests, String selectedMaterial) {
    return tests.where((test) => test.information.material == selectedMaterial).toList();
  }
}

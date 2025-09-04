part of 'offline_tests_bloc.dart';

abstract class OfflineTestsState extends Equatable {
  const OfflineTestsState();

  @override
  List<Object> get props => [];
}

class OfflineTestsMaterialPicker extends OfflineTestsState {}

class OfflineTestsLoading extends OfflineTestsState {}

class OfflineTestsInitial extends OfflineTestsState {
  final String selectedMaterial;
  final List<Test> cachedTests;
  final String? message;

  const OfflineTestsInitial({
    required this.selectedMaterial,
    this.cachedTests = const [],
    this.message,
  });

  @override
  List<Object> get props => [selectedMaterial, cachedTests, message ?? ''];

  OfflineTestsInitial copyWith({
    String? selectedMaterial,
    List<Test>? cachedTests,
    String? message,
  }) {
    return OfflineTestsInitial(
      selectedMaterial: selectedMaterial ?? this.selectedMaterial,
      cachedTests: cachedTests ?? this.cachedTests,
      message: message,
    );
  }
}

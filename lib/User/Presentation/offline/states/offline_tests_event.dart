part of 'offline_tests_bloc.dart';

abstract class OfflineTestsEvent extends Equatable {
  const OfflineTestsEvent();

  @override
  List<Object> get props => [];
}

class InitializeOfflineTests extends OfflineTestsEvent {}

class SelectMaterial extends OfflineTestsEvent {
  final String material;

  const SelectMaterial({required this.material});

  @override
  List<Object> get props => [material];
}

class DeleteTestFromCache extends OfflineTestsEvent {
  final int testId;

  const DeleteTestFromCache({required this.testId});

  @override
  List<Object> get props => [testId];
}

class ClearAllCachedTests extends OfflineTestsEvent {}

class ResetToMaterialPicker extends OfflineTestsEvent {}
